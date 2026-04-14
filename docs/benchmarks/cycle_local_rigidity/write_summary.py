#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CERT = ROOT / "certificates"
ART = ROOT / "artifacts"


def main() -> None:
    ART.mkdir(parents=True, exist_ok=True)
    rows = []
    for cert_path in sorted(CERT.glob("*.json")):
        c = json.loads(cert_path.read_text(encoding="utf-8"))
        rows.append({
            "graph_id": c["graph_id"],
            "family": c["family"],
            "n": c["n"],
            "m": c["m"],
            "max_degree": c["max_degree"],
            "k": c["k"],
            "R": c["R"],
            "cycle_overlap_rank": c["cycle_overlap_rank"],
            "local_type_count": c["local_type_count"],
            "threshold": c["threshold"],
            "status": c["status"],
        })
    with (ART / "summary.csv").open("w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(
            fh,
            fieldnames=[
                "graph_id",
                "family",
                "n",
                "m",
                "max_degree",
                "k",
                "R",
                "cycle_overlap_rank",
                "local_type_count",
                "threshold",
                "status",
            ],
        )
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
