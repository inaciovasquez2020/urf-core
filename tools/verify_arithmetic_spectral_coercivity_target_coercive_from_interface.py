from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
lean_path = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityTargetCoerciveFromInterface.lean"
urf_path = ROOT / "lean" / "URF.lean"

if not lean_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF/Frontier/ArithmeticSpectralCoercivityTargetCoerciveFromInterface.lean")
if not urf_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF.lean")

text = lean_path.read_text()
urf_text = urf_path.read_text()

required_fragments = [
    "import URF.Frontier.ArithmeticSpectralCoercivityInputInterface",
    "theorem arithmeticSpectralCoercivityTarget_coercive_from_interface",
    "(I : ArithmeticSpectralCoercivityInputInterface)",
    "I.arithmeticSpectralBridgeHypothesis",
    "ArithmeticSpectralCoercivityTarget_coercive",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_CONDITIONAL_THEOREM_RECORDED : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_ANALYTIC_BRIDGE_PROVED : Bool := false",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FINAL_CLOSURE_CLAIMED : Bool := false",
]

for fragment in required_fragments:
    if fragment not in text:
        raise SystemExit(f"MISSING_OBJECT := {fragment}")

for forbidden_decl in ["axiom", "opaque"]:
    if re.search(rf"(?m)^\s*{forbidden_decl}\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean declaration present: {forbidden_decl}")

for forbidden_token in ["sorry", "admit"]:
    if re.search(rf"\b{forbidden_token}\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean proof placeholder present: {forbidden_token}")

if "ARITHMETIC_SPECTRAL_COERCIVITY_ANALYTIC_BRIDGE_PROVED : Bool := true" in text:
    raise SystemExit("BOUNDARY := analytic bridge closure claimed")

if "ARITHMETIC_SPECTRAL_COERCIVITY_FINAL_CLOSURE_CLAIMED : Bool := true" in text:
    raise SystemExit("BOUNDARY := final closure claimed")

import_line = "import URF.Frontier.ArithmeticSpectralCoercivityTargetCoerciveFromInterface"
if import_line not in urf_text.splitlines():
    raise SystemExit("MISSING_OBJECT := import URF.Frontier.ArithmeticSpectralCoercivityTargetCoerciveFromInterface")

print("ARITHMETIC_SPECTRAL_COERCIVITY_CONDITIONAL_THEOREM_OK")
