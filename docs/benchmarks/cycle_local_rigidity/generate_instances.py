#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
INST = ROOT / "instances"


def write_graph(graph_id: str, family: str, n: int, edges):
    data = {
        "graph_id": graph_id,
        "family": family,
        "n": n,
        "edges": [list(e) for e in edges],
    }
    (INST / f"{graph_id}.json").write_text(json.dumps(data, indent=2), encoding="utf-8")


def path_graph(n: int):
    return [(i, i + 1) for i in range(n - 1)]


def cycle_graph(n: int):
    return [(i, (i + 1) % n) for i in range(n)]


def lollipop():
    edges = cycle_graph(6)
    edges += [(5, 6), (6, 7), (7, 8)]
    return 9, edges


def theta_graph():
    edges = [
        (0, 1), (1, 2), (2, 5),
        (0, 3), (3, 4), (4, 5),
        (0, 6), (6, 7), (7, 5),
    ]
    return 8, edges


def main() -> None:
    INST.mkdir(parents=True, exist_ok=True)
    write_graph("G_tree_001", "tree", 8, path_graph(8))
    write_graph("G_unicyclic_001", "unicyclic", 8, cycle_graph(8))
    n, edges = lollipop()
    write_graph("G_expander_like_001", "expander-like", n, edges)
    n, edges = theta_graph()
    write_graph("G_gadget_001", "gadget", n, edges)


if __name__ == "__main__":
    main()
