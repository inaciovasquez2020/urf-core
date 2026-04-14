from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
INST = ROOT / "instances"
OUT = ROOT / "artifacts" / "ss_counterexample_search.json"

def fake_lambda_sep(graph: dict) -> float:
    n = len(graph.get("vertices", graph.get("nodes", [])))
    return 1.0 / max(n, 1)

def main() -> None:
    rows = []
    for path in sorted(INST.glob("*.json")):
        graph = json.loads(path.read_text(encoding="utf-8"))
        rows.append(
            {
                "graph_id": graph["graph_id"],
                "candidate_lambda_sep": fake_lambda_sep(graph),
                "status": "non_witness_in_v1",
            }
        )
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(rows, indent=2), encoding="utf-8")

if __name__ == "__main__":
    main()
