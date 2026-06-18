#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ARTIFACT = Path("artifacts/urf/emergent_metric_einstein_limit_obligation_2026_06_18.json")
LEAN = Path("lean/URF/Frontier/EmergentMetricEinsteinLimitObligation.lean")
IMPORT_ROOT = Path("lean/URF.lean")

REJECTED_CLAIMS = {
    "Einstein_limit_proved",
    "field_equations_derived",
    "gravity_solved",
    "quantum_gravity_closed",
    "experimental_confirmation",
}

REQUIRED_SUB_OBLIGATIONS = {
    "construct a ScalingLimit from QFTState to an EmergentMetric candidate",
    "prove nondegenerate Lorentzian or Einstein-Cartan-compatible geometric structure where required",
    "identify stress-energy and cosmological terms from source data",
    "prove LeadingOrderEinsteinLimit in an explicitly bounded approximation regime",
    "recheck all boundary guards after any attempted discharge",
}


def fail(message: str) -> None:
    raise SystemExit(f"EMERGENT_METRIC_EINSTEIN_LIMIT_OBLIGATION_FAIL: {message}")


def read(path: Path) -> str:
    if not path.exists():
        fail(f"missing {path}")
    return path.read_text()


def main() -> None:
    raw = read(ARTIFACT)
    lean = read(LEAN)
    root = read(IMPORT_ROOT)
    data = json.loads(raw)

    if data.get("artifact_id") != "EMERGENT_METRIC_EINSTEIN_LIMIT_OBLIGATION_2026_06_18":
        fail("artifact_id changed")

    if data.get("status") != "open_obligation_only":
        fail("status must remain open_obligation_only")

    if data.get("boundary") != "BOUNDARY := ¬ Einstein_limit_proved":
        fail("boundary must remain exact")

    does_not_claim = data.get("does_not_claim")
    if not isinstance(does_not_claim, dict):
        fail("does_not_claim missing")

    for claim in REJECTED_CLAIMS:
        if does_not_claim.get(claim) is not False:
            fail(f"claim guard must reject {claim}")

    missing_bridge = data.get("missing_bridge")
    if not isinstance(missing_bridge, dict):
        fail("missing_bridge missing")

    sub_obligations = set(missing_bridge.get("sub_obligations", []))
    if sub_obligations != REQUIRED_SUB_OBLIGATIONS:
        fail("sub_obligations changed")

    if "GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_2026_06_18" not in data.get("depends_on", []):
        fail("source-map dependency missing")

    forbidden_markers = ("axiom", "opaque", "sorry", "admit")
    lowered = lean.lower()
    for marker in forbidden_markers:
        if marker in lowered:
            fail(f"Lean file contains forbidden marker {marker}")

    required_lean_tokens = (
        "structure EmergentMetricEinsteinLimitObligation",
        "def LeadingOrderEinsteinLimit",
        "boundaryNoEinsteinLimitProved",
        "boundaryNoFieldEquationsDerived",
        "boundaryNoGravitySolved",
        "boundaryNoQuantumGravityClosed",
        "boundaryNoExperimentalConfirmation",
        "theorem EmergentMetricEinsteinLimitObligation.boundaries",
        "theorem EmergentMetricEinsteinLimitObligation.missingBridge",
    )
    for token in required_lean_tokens:
        if token not in lean:
            fail(f"Lean token missing: {token}")

    if "import URF.Frontier.EmergentMetricEinsteinLimitObligation" not in root:
        fail("URF import missing")

    print("EMERGENT_METRIC_EINSTEIN_LIMIT_OBLIGATION_OK")


if __name__ == "__main__":
    main()
