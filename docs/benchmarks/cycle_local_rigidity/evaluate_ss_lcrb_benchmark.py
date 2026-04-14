from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CERTS = ROOT / "certificates"
OUT = ROOT / "artifacts" / "ss_lcrb_empirical_report.json"

def candidate_lambda_sep(cert: dict) -> float:
    n = int(cert.get("n", 0) or 0)
    local_type_count = int(cert.get("local_type_count", 0) or 0)
    return local_type_count / max(n, 1)

def main() -> None:
    rows = []
    for path in sorted(CERTS.glob("*.json")):
        cert = json.loads(path.read_text(encoding="utf-8"))
        rows.append(
            {
                "graph_id": cert.get("graph_id", path.stem),
                "n": int(cert.get("n", 0) or 0),
                "local_type_count": int(cert.get("local_type_count", 0) or 0),
                "cycle_overlap_rank": int(cert.get("cycle_overlap_rank", 0) or 0),
                "candidate_lambda_sep": candidate_lambda_sep(cert),
            }
        )

    homogeneous = [r for r in rows if r["local_type_count"] == 1]

    report = {
        "graphs_total": len(rows),
        "homogeneous_graphs_total": len(homogeneous),
        "min_candidate_lambda_sep_on_homogeneous": (
            min((r["candidate_lambda_sep"] for r in homogeneous), default=None)
        ),
        "max_cycle_overlap_rank_on_homogeneous": (
            max((r["cycle_overlap_rank"] for r in homogeneous), default=None)
        ),
        "ssw_empirical_counterexample_found": any(
            r["local_type_count"] == 1 and r["candidate_lambda_sep"] == 0 for r in rows
        ),
        "lcrb_benchmark_upper_bound_observed": (
            max((r["cycle_overlap_rank"] for r in homogeneous), default=None)
        ),
        "promotion_admissible": False,
        "promotion_blocker": (
            "Missing repository-native implication from benchmark evidence "
            "to quantified theorem statement."
        ),
        "rows": rows,
    }

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(report, indent=2), encoding="utf-8")

if __name__ == "__main__":
    main()
