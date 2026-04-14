#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from collections import deque
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple, Set


@dataclass(frozen=True)
class Graph:
    graph_id: str
    family: str
    n: int
    edges: List[Tuple[int, int]]

    @property
    def m(self) -> int:
        return len(self.edges)


def load_graph(path: Path) -> Graph:
    data = json.loads(path.read_text(encoding="utf-8"))
    graph_id = data["graph_id"]
    family = data["family"]
    n = int(data["n"])
    edges = [tuple(map(int, e)) for e in data["edges"]]
    if n < 0:
        raise ValueError("n must be nonnegative")
    for u, v in edges:
        if not (0 <= u < n and 0 <= v < n):
            raise ValueError("edge endpoint out of range")
        if u == v:
            raise ValueError("loops not allowed")
    return Graph(graph_id=graph_id, family=family, n=n, edges=edges)


def adjacency(graph: Graph) -> Dict[int, Set[int]]:
    adj: Dict[int, Set[int]] = {i: set() for i in range(graph.n)}
    for u, v in graph.edges:
        adj[u].add(v)
        adj[v].add(u)
    return adj


def max_degree(graph: Graph) -> int:
    adj = adjacency(graph)
    return max((len(adj[v]) for v in range(graph.n)), default=0)


def connected(graph: Graph) -> bool:
    if graph.n == 0:
        return True
    adj = adjacency(graph)
    seen = set()
    q = deque([0])
    seen.add(0)
    while q:
        x = q.popleft()
        for y in adj[x]:
            if y not in seen:
                seen.add(y)
                q.append(y)
    return len(seen) == graph.n


def bfs_distances(graph: Graph, root: int, R: int) -> Dict[int, int]:
    adj = adjacency(graph)
    dist = {root: 0}
    q = deque([root])
    while q:
        x = q.popleft()
        if dist[x] == R:
            continue
        for y in sorted(adj[x]):
            if y not in dist:
                dist[y] = dist[x] + 1
                q.append(y)
    return dist


def rooted_ball_signature(graph: Graph, root: int, R: int) -> Tuple:
    dist = bfs_distances(graph, root, R)
    verts = sorted(dist.keys(), key=lambda v: (dist[v], v))
    idx = {v: i for i, v in enumerate(verts)}
    adj = adjacency(graph)
    edge_list = []
    for u in verts:
        for v in adj[u]:
            if v in idx and idx[u] < idx[v]:
                edge_list.append((idx[u], idx[v]))
    return (
        tuple(dist[v] for v in verts),
        tuple(sorted(edge_list)),
    )


def local_type_signatures(graph: Graph, R: int) -> Dict[int, Tuple]:
    return {v: rooted_ball_signature(graph, v, R) for v in range(graph.n)}


def local_type_count(graph: Graph, R: int) -> int:
    return len(set(local_type_signatures(graph, R).values()))


def spanning_tree_parents(graph: Graph) -> Tuple[Dict[int, int], List[Tuple[int, int]]]:
    adj = adjacency(graph)
    parent = {0: -1}
    order = [0]
    q = deque([0])
    while q:
        x = q.popleft()
        for y in sorted(adj[x]):
            if y not in parent:
                parent[y] = x
                order.append(y)
                q.append(y)
    if len(parent) != graph.n:
        raise ValueError("graph must be connected")
    tree_edges = []
    for v in range(graph.n):
        if parent[v] != -1:
            a, b = sorted((v, parent[v]))
            tree_edges.append((a, b))
    return parent, tree_edges


def path_to_root(parent: Dict[int, int], v: int) -> List[int]:
    path = []
    while v != -1:
        path.append(v)
        v = parent[v]
    return path


def tree_distance(parent: Dict[int, int], u: int, v: int) -> int:
    pu = path_to_root(parent, u)
    pv = path_to_root(parent, v)
    su = {x: i for i, x in enumerate(pu)}
    for j, x in enumerate(pv):
        if x in su:
            return su[x] + j
    raise RuntimeError("LCA not found")


def cycle_overlap_rank_v1(graph: Graph, R: int) -> int:
    parent, tree_edges = spanning_tree_parents(graph)
    tree_edge_set = set(tree_edges)
    count = 0
    for e in graph.edges:
        a, b = sorted(e)
        if (a, b) in tree_edge_set:
            continue
        cycle_len = tree_distance(parent, a, b) + 1
        if cycle_len > 2 * R + 1:
            count += 1
    return count


def verify(graph_path: Path, cert_path: Path, delta: int = 4) -> int:
    graph = load_graph(graph_path)
    cert = json.loads(cert_path.read_text(encoding="utf-8"))

    if graph.graph_id != cert["graph_id"]:
        raise AssertionError("graph_id mismatch")
    if graph.family != cert["family"]:
        raise AssertionError("family mismatch")
    if graph.n != int(cert["n"]):
        raise AssertionError("n mismatch")
    if graph.m != int(cert["m"]):
        raise AssertionError("m mismatch")
    if max_degree(graph) != int(cert["max_degree"]):
        raise AssertionError("max_degree mismatch")
    if max_degree(graph) > delta:
        raise AssertionError("degree bound violated")
    if not connected(graph):
        raise AssertionError("graph is not connected")

    k = int(cert["k"])
    R = int(cert["R"])
    threshold = int(cert["threshold"])
    if k != 3:
        raise AssertionError("benchmark v1 fixes k=3")
    if R != 2:
        raise AssertionError("benchmark v1 fixes R=2")

    ltc = local_type_count(graph, R)
    cor = cycle_overlap_rank_v1(graph, R)

    if ltc != int(cert["local_type_count"]):
        raise AssertionError("local_type_count mismatch")
    if cor != int(cert["cycle_overlap_rank"]):
        raise AssertionError("cycle_overlap_rank mismatch")

    expected_status = "rigidity_triggered" if cor >= threshold else "no_trigger"
    if cert["status"] != expected_status:
        raise AssertionError("status mismatch")

    witness = cert.get("witness", {})
    if expected_status == "rigidity_triggered":
        a = int(witness["type_a_vertex"])
        b = int(witness["type_b_vertex"])
        sigs = local_type_signatures(graph, R)
        if sigs[a] == sigs[b]:
            raise AssertionError("witness vertices do not exhibit distinct local types")

    return 0


def main(argv: List[str]) -> int:
    if len(argv) != 3:
        print("usage: verify.py GRAPH.json CERTIFICATE.json", file=sys.stderr)
        return 2
    try:
        return verify(Path(argv[1]), Path(argv[2]))
    except Exception as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
