#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "lean" / "URF" / "Frontier" / "MetricLikeCandidateConstructionObligation.lean"
ROOT_LEAN = ROOT / "lean" / "URF.lean"

lean = LEAN.read_text()
root = ROOT_LEAN.read_text()

forbidden = ("axiom", "opaque", "sorry", "admit")
lowered = lean.lower()
for marker in forbidden:
    if marker in lowered:
        raise SystemExit(f"METRIC_LIKE_CANDIDATE_CONSTRUCTION_OBLIGATION_FAIL: forbidden marker {marker}")

required = [
    "namespace MetricLikeCandidateConstructionObligation",
    "structure MetricLikeCandidate",
    "structure MetricLikeStructureControl",
    "structure Obligation",
    "theorem Obligation.boundaries",
    "theorem Obligation.missingBridge",
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

if "import URF.Frontier.MetricLikeCandidateConstructionObligation" not in root:
    missing.append("root import")

if missing:
    raise SystemExit("METRIC_LIKE_CANDIDATE_CONSTRUCTION_OBLIGATION_FAIL: missing " + ", ".join(missing))

print("METRIC_LIKE_CANDIDATE_CONSTRUCTION_OBLIGATION_OK")
