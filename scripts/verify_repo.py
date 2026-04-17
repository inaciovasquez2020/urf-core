#!/usr/bin/env python3
from pathlib import Path
import sys

required = [
    "README.md",
    ".gitmodules",
    "Chronos-EntropyDepth",
    "CorrRank",
    "aiv-verifier-public",
    "bepty",
    "biological-friction-framework",
    "capacity-locality-certification",
    "cells-downwards-rh",
    "chronos-urf-rr",
    "clay-problem-lab",
    "cslib-fmt",
    "cycle-local-rigidity",
    "cyclone-terminal-obstruction",
    "poincare-new-derivation",
    "radiative-rigidity",
    "scientific-infrastructure",
    "urf-axioms",
    "urf-core",
    "urf-minimal-obstruction",
    "urf-prefab-system",
    "urf-textbook",
    "vasquez-index",
    "whiplash-stability",
    "yang-mills-hs-gap-cert",
    "ym-os-quantization",
    "ym-spectral-wall-next",
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
    "mentions_verification_or_submodules": (
        "verification" in readme or "submodules" in readme
    ),
    "gitmodules_mentions_urf_core": "urf-core" in gitmodules,
    "gitmodules_mentions_vasquez_index": "vasquez-index" in gitmodules,
    "gitmodules_mentions_radiative_rigidity": "radiative-rigidity" in gitmodules,
}

failed = [k for k, v in checks.items() if not v]
if failed:
    print({"valid": False, "failed_checks": failed, "checks": checks})
    sys.exit(1)

print({"valid": True, "checked": required, "checks": checks})
