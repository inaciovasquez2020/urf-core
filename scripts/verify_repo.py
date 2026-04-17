#!/usr/bin/env python3
from pathlib import Path
import sys

required = [
    "README.md",
    "CITATION.cff",
    "Makefile",
    "FREEZE.md",
    "CLAIMS.md",
    "FINAL_WALL.md",
    "QUICKSTART.md",
    "PROOF_INFRASTRUCTURE.md",
    "src",
    "tests",
    "toolkit",
    "verification",
    "verify",
    "schema",
    "scripts",
]

missing = [p for p in required if not Path(p).exists()]
if missing:
    print({"valid": False, "missing": missing})
    sys.exit(1)

checks = {}

readme = Path("README.md").read_text(errors="ignore").lower()
checks["mentions_unified_rigidity_framework"] = (
    "unified rigidity framework" in readme or "urf" in readme
)
checks["mentions_definitions_or_schemas"] = (
    "definitions" in readme or "schemas" in readme or "verification" in readme
)

claims = Path("CLAIMS.md").read_text(errors="ignore").lower()
checks["claims_nonempty"] = len(claims.strip()) > 0

freeze = Path("FREEZE.md").read_text(errors="ignore").lower()
checks["freeze_mentions_freeze_or_canonical"] = (
    "freeze" in freeze or "canonical" in freeze
)

final_wall = Path("FINAL_WALL.md").read_text(errors="ignore").lower()
checks["final_wall_nonempty"] = len(final_wall.strip()) > 0

failed = [k for k, v in checks.items() if not v]
if failed:
    print({"valid": False, "failed_checks": failed, "checks": checks})
    sys.exit(1)

print({"valid": True, "checked": required, "checks": checks})
