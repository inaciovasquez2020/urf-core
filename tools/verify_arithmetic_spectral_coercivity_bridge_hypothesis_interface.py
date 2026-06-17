from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
lean_path = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityBridgeHypothesisInterface.lean"
urf_path = ROOT / "lean" / "URF.lean"

if not lean_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF/Frontier/ArithmeticSpectralCoercivityBridgeHypothesisInterface.lean")
if not urf_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF.lean")

text = lean_path.read_text()
urf_text = urf_path.read_text()

required_fragments = [
    "import URF.Frontier.ArithmeticSpectralCoercivityInputInterface",
    "structure ArithmeticSpectralCoercivityBridgeHypothesisInterface where",
    "input : ArithmeticSpectralCoercivityInputInterface",
    "arithmeticStructureNonemptyAssumption : Prop",
    "arithmeticAdmissibilityStabilityAssumption : Prop",
    "arithmeticNondegeneracyAssumption : Prop",
    "arithmeticScaleControlAssumption : Prop",
    "spectralOperatorCompatibilityAssumption : Prop",
    "spectralEnergyLowerBoundAssumption : Prop",
    "spectralNormControlAssumption : Prop",
    "spectralTestVectorCoverageAssumption : Prop",
    "bridgeTransfersArithmeticToSpectralAssumption : Prop",
    "bridgeSuppliesInputHypothesisAssumption : Prop",
    "boundaryNoAnalyticBridgeProof : Prop",
    "boundaryNoFinalCoercivityClosureClaim : Prop",
    "def ArithmeticSpectralCoercivityBridgeHypothesisInterface.arithmeticAssumptions",
    "def ArithmeticSpectralCoercivityBridgeHypothesisInterface.spectralAssumptions",
    "def ArithmeticSpectralCoercivityBridgeHypothesisInterface.boundary",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_BRIDGE_HYPOTHESIS_INTERFACE_RECORDED : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_BRIDGE_HYPOTHESIS_INTERFACE_BOUNDARY_ONLY : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_ANALYTIC_BRIDGE_CLOSED : Bool := false",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FINAL_CLOSURE_CLAIMED_BY_BRIDGE_INTERFACE : Bool := false",
]

for fragment in required_fragments:
    if fragment not in text:
        raise SystemExit(f"MISSING_OBJECT := {fragment}")

for forbidden_decl in ["axiom", "opaque", "theorem"]:
    if re.search(rf"(?m)^\s*{forbidden_decl}\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean closure declaration present: {forbidden_decl}")

for forbidden_token in ["sorry", "admit"]:
    if re.search(rf"\b{forbidden_token}\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean placeholder present: {forbidden_token}")

for forbidden_claim in [
    "ARITHMETIC_SPECTRAL_COERCIVITY_ANALYTIC_BRIDGE_CLOSED : Bool := true",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FINAL_CLOSURE_CLAIMED_BY_BRIDGE_INTERFACE : Bool := true",
]:
    if forbidden_claim in text:
        raise SystemExit(f"BOUNDARY := forbidden final closure claim present: {forbidden_claim}")

import_line = "import URF.Frontier.ArithmeticSpectralCoercivityBridgeHypothesisInterface"
if import_line not in urf_text.splitlines():
    raise SystemExit("MISSING_OBJECT := import URF.Frontier.ArithmeticSpectralCoercivityBridgeHypothesisInterface")

print("ARITHMETIC_SPECTRAL_COERCIVITY_BRIDGE_HYPOTHESIS_INTERFACE_BOUNDARY_OK")
