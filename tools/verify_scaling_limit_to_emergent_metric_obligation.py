#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ARTIFACT = Path("artifacts/urf/scaling_limit_to_emergent_metric_obligation_2026_06_18.json")
STATUS = Path("docs/status/SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_2026_06_18.md")
LEAN = Path("lean/URF/Frontier/ScalingLimitToEmergentMetricObligation.lean")
ROOT = Path("lean/URF.lean")

REJECTED = {
    "emergent_metric_constructed",
    "scaling_limit_converges",
    "Lorentzian_signature_proved",
    "Einstein_limit_proved",
    "field_equations_derived",
    "gravity_solved",
}

REQUIRED_SUB_OBLIGATIONS = {
    "define QFT-side source data sufficient to generate candidate geometric observables",
    "define a scaling-limit procedure with explicit regime parameters",
    "prove convergence or controlled approximation of the geometric observables",
    "prove the resulting candidate is metric-like in the required low-energy regime",
    "record that Einstein-limit and field-equation derivation remain separate later obligations",
}


def fail(message: str) -> None:
    raise SystemExit(f"SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_FAIL: {message}")


def read(path: Path) -> str:
    if not path.exists():
        fail(f"missing {path}")
    return path.read_text()


def main() -> None:
    raw = read(ARTIFACT)
    status = read(STATUS)
    lean = read(LEAN)
    root = read(ROOT)
    data = json.loads(raw)

    if data.get("artifact_id") != "SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_2026_06_18":
        fail("artifact_id changed")

    if data.get("status") != "open_obligation_only":
        fail("status must remain open_obligation_only")

    if data.get("boundary") != "BOUNDARY := ¬ emergent_metric_constructed":
        fail("boundary must remain exact")

    claims = data.get("does_not_claim")
    if not isinstance(claims, dict):
        fail("does_not_claim missing")

    for claim in REJECTED:
        if claims.get(claim) is not False:
            fail(f"claim guard must reject {claim}")

    missing_bridge = data.get("missing_bridge")
    if not isinstance(missing_bridge, dict):
        fail("missing_bridge missing")

    if set(missing_bridge.get("sub_obligations", [])) != REQUIRED_SUB_OBLIGATIONS:
        fail("sub_obligations changed")

    dependencies = set(data.get("depends_on", []))
    if "GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_2026_06_18" not in dependencies:
        fail("source-map dependency missing")
    if "EMERGENT_METRIC_EINSTEIN_LIMIT_OBLIGATION_2026_06_18" not in dependencies:
        fail("Einstein-limit obligation dependency missing")

    lowered = lean.lower()
    for marker in ("axiom", "opaque", "sorry", "admit"):
        if marker in lowered:
            fail(f"Lean file contains forbidden marker {marker}")

    required_lean_tokens = (
        "namespace ScalingLimitToEmergentMetricObligation",
        "structure QFTSourceData",
        "structure ScalingLimitProcedure",
        "structure GeometricObservableCandidate",
        "structure EmergentMetricCandidate",
        "structure Obligation",
        "theorem Obligation.boundaries",
        "theorem Obligation.missingBridge",
    )
    for token in required_lean_tokens:
        if token not in lean:
            fail(f"Lean token missing: {token}")

    if "BOUNDARY := ¬ emergent_metric_constructed" not in status:
        fail("status boundary missing")

    if "import URF.Frontier.ScalingLimitToEmergentMetricObligation" not in root:
        fail("URF import missing")

    print("SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_OK")


if __name__ == "__main__":
    main()
