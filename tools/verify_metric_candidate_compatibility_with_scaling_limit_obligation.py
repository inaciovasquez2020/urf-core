#!/usr/bin/env python3
from pathlib import Path

LEAN = Path("lean/URF/Frontier/MetricCandidateCompatibilityWithScalingLimitObligation.lean")
ROOT = Path("lean/URF.lean")


def fail(message: str) -> None:
    raise SystemExit(
        "METRIC_CANDIDATE_COMPATIBILITY_WITH_SCALING_LIMIT_OBLIGATION_FAIL: "
        + message
    )


def read(path: Path) -> str:
    if not path.exists():
        fail(f"missing {path}")
    return path.read_text()


lean = read(LEAN)
root = read(ROOT)

lowered = lean.lower()
for marker in ("axiom", "opaque", "sorry", "admit"):
    if marker in lowered:
        fail(f"Lean file contains forbidden marker {marker}")

required = [
    "namespace MetricCandidateCompatibilityWithScalingLimitObligation",
    "structure MetricCandidateScalingCompatibility",
    "structure Obligation",
    "theorem Obligation.boundaries",
    "theorem Obligation.missingBridge",
    "boundaryNoMetricCandidateScalingCompatibilityProved",
    "boundaryNoMetricLikeCandidateConstructed",
    "boundaryNoGeometricObservableConvergenceProved",
    "boundaryNoEmergentMetricConstructed",
    "boundaryNoScalingLimitConverges",
    "boundaryNoLorentzianSignatureProved",
    "boundaryNoEinsteinLimitProved",
    "boundaryNoFieldEquationsDerived",
    "boundaryNoGravitySolved",
]

missing = [token for token in required if token not in lean]

if "import URF.Frontier.MetricCandidateCompatibilityWithScalingLimitObligation" not in root:
    missing.append("root import")

if missing:
    fail("missing " + ", ".join(missing))

print("METRIC_CANDIDATE_COMPATIBILITY_WITH_SCALING_LIMIT_OBLIGATION_OK")
