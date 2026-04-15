from __future__ import annotations
import json
from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
INP = ROOT / "artifacts" / "urf_des_real_eval_inputs"
OUT = ROOT / "artifacts" / "urf_des_real_eval_outputs" / "real_eval.json"

REQ = {
    "covariance": INP / "des_like_covariance.csv",
    "u_urf": INP / "u_urf.csv",
    "u_ia": INP / "u_ia.csv",
    "u_bar": INP / "u_bar.csv",
    "u_cal": INP / "u_cal.csv",
}

def count_rows(p: Path) -> int:
    with p.open(newline="") as f:
        return sum(1 for _ in csv.reader(f))

missing = [str(p) for p in REQ.values() if not p.is_file()]

OUT.parent.mkdir(parents=True, exist_ok=True)

payload = {
    "real_data_mode": True,
    "inputs_present": {k: p.is_file() for k, p in REQ.items()},
    "missing_inputs": missing,
    "covariance_rows": count_rows(REQ["covariance"]) if REQ["covariance"].is_file() else 0,
    "status": "blocked_missing_authentic_vectors" if missing else "ready_for_real_numeric_evaluation",
}

OUT.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
print(OUT)
