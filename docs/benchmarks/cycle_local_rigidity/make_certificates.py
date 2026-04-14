#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

from verify import load_graph, max_degree, local_type_count, local_type_signatures, cycle_overlap_rank_v1


ROOT = Path(__file__).resolve().parent
INST = ROOT / "instances"
CERT = ROOT / "certificates"


def choose_witness(graph, R: int):
    sigs = local_type_signatures(graph, R)
    verts = list(sorted(sigs))
    for i, a in enumerate(verts):
        for b in verts[i + 1:]:
            if sigs[a] != sigs[b]:
                return {"type_a_vertex": a, "type_b_vertex": b}
    return {}


def main() -> None:
    CERT.mkdir(parents=True, exist_ok=True)
    for graph_path in sorted(INST.glob("*.json")):
        graph = load_graph(graph_path)
        R = 2
        T0 = 1
        ltc = local_type_count(graph, R)
        cor = cycle_overlap_rank_v1(graph, R)
        status = "rigidity_triggered" if cor >= T0 else "no_trigger"
        cert = {
            "graph_id": graph.graph_id,
            "family": graph.family,
            "n": graph.n,
            "m": graph.m,
            "max_degree": max_degree(graph),
            "k": 3,
            "R": 2,
            "threshold": T0,
            "local_type_count": ltc,
            "cycle_overlap_rank": cor,
            "status": status,
            "witness": choose_witness(graph, R) if status == "rigidity_triggered" else {},
        }
        (CERT / f"{graph.graph_id}.certificate.json").write_text(
            json.dumps(cert, indent=2),
            encoding="utf-8",
        )


if __name__ == "__main__":
    main()
