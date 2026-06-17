from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
lean_path = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityInputInterface.lean"
urf_path = ROOT / "lean" / "URF.lean"

if not lean_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF/Frontier/ArithmeticSpectralCoercivityInputInterface.lean")
if not urf_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF.lean")

text = lean_path.read_text()
urf_text = urf_path.read_text()

required_fragments = [
    "structure ArithmeticSpectralCoercivityInputInterface where",
    "arithmeticStructure : Type",
    "spectralSpace : Type",
    "spectralOperator : spectralSpace → spectralSpace",
    "arithmeticSpectralBridgeHypothesis : Prop",
    "coercivityConstantPositiveHypothesis : Prop",
    "boundaryNoCoercivityProof : Prop",
    "boundaryNoFinalTheoremClosureClaim : Prop",
    "def ArithmeticSpectralCoercivityInputInterface.boundary",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_INPUT_INTERFACE_RECORDED : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_THEOREM_PROVED : Bool := false",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_INPUT_INTERFACE_BOUNDARY_ONLY : Bool := true",
]

for fragment in required_fragments:
    if fragment not in text:
        raise SystemExit(f"MISSING_OBJECT := {fragment}")

import re

for forbidden_decl in ["axiom", "opaque", "theorem"]:
    if re.search(rf"(?m)^\\s*{forbidden_decl}\\b", text):
        raise SystemExit(
            f"BOUNDARY := forbidden Lean proof/closure declaration present: {forbidden_decl}"
        )

for forbidden_token in ["sorry", "admit"]:
    if re.search(rf"\\b{forbidden_token}\\b", text):
        raise SystemExit(
            f"BOUNDARY := forbidden Lean proof placeholder present: {forbidden_token}"
        )

import_line = "import URF.Frontier.ArithmeticSpectralCoercivityInputInterface"
if import_line not in urf_text.splitlines():
    raise SystemExit("MISSING_OBJECT := import URF.Frontier.ArithmeticSpectralCoercivityInputInterface")

print("ARITHMETIC_SPECTRAL_COERCIVITY_INPUT_INTERFACE_BOUNDARY_OK")
