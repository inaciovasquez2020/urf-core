#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
VERIFY = ROOT / "verify.py"
INST = ROOT / "instances"
CERT = ROOT / "certificates"


def main() -> int:
    for graph_path in sorted(INST.glob("*.json")):
        cert_path = CERT / f"{graph_path.stem}.certificate.json"
        proc = subprocess.run(
            [sys.executable, str(VERIFY), str(graph_path), str(cert_path)],
            cwd=ROOT,
        )
        if proc.returncode != 0:
            return proc.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
