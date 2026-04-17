#!/usr/bin/env python3
from pathlib import Path
import sys

required = [
    "README.md",
    ".gitmodules",
    "scripts",
]

missing = [p for p in required if not Path(p).exists()]
if missing:
    print({"valid": False, "missing": missing})
    sys.exit(1)

readme = Path("README.md").read_text(errors="ignore").lower()
gitmodules = Path(".gitmodules").read_text(errors="ignore").lower()

checks = {
    "mentions_urf_portfolio": "urf portfolio" in readme,
    "mentions_unified_rigidity_framework": (
        "unified rigidity framework" in readme or "urf" in readme
    ),
    "gitmodules_nonempty": len(gitmodules.strip()) > 0,
    "gitmodules_mentions_urf_core": "urf-core" in gitmodules,
    "gitmodules_mentions_vasquez_index": "vasquez-index" in gitmodules,
    "gitmodules_mentions_radiative_rigidity": "radiative-rigidity" in gitmodules,
}

failed = [k for k, v in checks.items() if not v]
if failed:
    print({"valid": False, "failed_checks": failed, "checks": checks})
    sys.exit(1)

print({"valid": True, "checked": required, "checks": checks})
