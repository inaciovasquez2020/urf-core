#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ARTIFACT = Path("artifacts/urf/geometric_observable_convergence_obligation_2026_06_18.json")
STATUS = Path("docs/status/GEOMETRIC_OBSERVABLE_CONVERGENCE_OBLIGATION_2026_06_18.md")
LEAN = Path("lean/URF/Frontier/GeometricObservableConvergenceObligation.lean")
ROOT = Path("lean/URF.lean")

REJECTED = {
    "geometric_observable_convergence_proved",
    "emergent_metric_constructed",
    "scaling_limit_converges",
    "Lorentzian_signature_proved",
    "Einstein_limit_proved",
    "field_equations_derived",
    "gravity_solved",
}

REQUIRED_SUB_OBLIGATIONS = {
    "define the geometric observables extracted from QFT-side source data",
    "define the topology or norm in which convergence is measured",
    "state the scaling regime and approximation parameters",
    "prove or bound convergence of the observables in that regime",
    "record that emergent metric construction and Einstein-limit recovery remain separate later obligations",
}


def fail(message: str) -> None:
    raise SystemExit(f"GEOMETRIC_OBSERVABLE_CONVERGENCE_OBLIGATION_FAIL: {message}")


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

    if data.get("artifact_id") != "GEOMETRIC_OBSERVABLE_CONVERGENCE_OBLIGATION_2026_06_18":
        fail("artifact_id changed")

    if data.get("status") != "open_obligation_only":
        fail("status must remain open_obligation_only")

    if data.get("boundary") != "BOUNDARY := ¬ geometric_observable_convergence_proved":
        fail("boundary must remain exact")

    dependencies = set(data.get("depends_on", []))
    if "SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_2026_06_18" not in dependencies:
        fail("scaling-limit dependency missing")

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

    lowered = lean.lower()
    for marker in ("axiom", "opaque", "sorry", "admit"):
        if marker in lowered:
            fail(f"Lean file contains forbidden marker {marker}")

    required_lean_tokens = (
        "namespace GeometricObservableConvergenceObligation",
        "structure QFTObservableSource",
        "structure GeometricObservable",
        "structure ConvergenceControl",
        "structure ScalingRegime",
        "structure Obligation",
        "theorem Obligation.boundaries",
        "theorem Obligation.missingBridge",
    )
    for token in required_lean_tokens:
        if token not in lean:
            fail(f"Lean token missing: {token}")

    if "BOUNDARY := ¬ geometric_observable_convergence_proved" not in status:
        fail("status boundary missing")

    if "import URF.Frontier.GeometricObservableConvergenceObligation" not in root:
        fail("URF import missing")

    print("GEOMETRIC_OBSERVABLE_CONVERGENCE_OBLIGATION_OK")


if __name__ == "__main__":
    main()
