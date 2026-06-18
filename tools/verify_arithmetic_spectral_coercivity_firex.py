from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
lean_path = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityFireX.lean"
urf_path = ROOT / "lean" / "URF.lean"

if not lean_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF/Frontier/ArithmeticSpectralCoercivityFireX.lean")
if not urf_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF.lean")

text = lean_path.read_text()
urf_text = urf_path.read_text()

required_fragments = [
    "import URF.Frontier.ArithmeticSpectralCoercivityBridgeToInputLemma",
    "structure FireX",
    "(B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)",
    "suppliesInputHypothesis :",
    "B.bridgeSuppliesInputHypothesisAssumption →",
    "B.input.arithmeticSpectralBridgeHypothesis",
    "theorem arithmeticSpectralCoercivity_fireX_supplies_inputHypothesis",
    "(hB : B.boundary)",
    "(fireX : FireX B)",
    "arithmeticSpectralCoercivityBridge_supplies_inputHypothesis_conditional",
    "B hB fireX.suppliesInputHypothesis",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_RECORDED : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_ONLY : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_ANALYTIC_BRIDGE_CLOSED : Bool := false",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_FINAL_CLOSURE_CLAIMED : Bool := false",
]

for fragment in required_fragments:
    if fragment not in text:
        raise SystemExit(f"MISSING_OBJECT := {fragment}")

for forbidden_decl in ["axiom", "opaque"]:
    if re.search(rf"(?m)^\\s*{forbidden_decl}\\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean declaration present: {forbidden_decl}")

for forbidden_token in ["sorry", "admit"]:
    if re.search(rf"\\b{forbidden_token}\\b", text):
        raise SystemExit(f"BOUNDARY := forbidden Lean proof placeholder present: {forbidden_token}")

for forbidden_claim in [
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_ANALYTIC_BRIDGE_CLOSED : Bool := true",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_FINAL_CLOSURE_CLAIMED : Bool := true",
]:
    if forbidden_claim in text:
        raise SystemExit(f"BOUNDARY := forbidden closure claim present: {forbidden_claim}")

for overclaim in [
    "final theorem closure",
    "full theorem layer is complete",
    "general mathematical problem is solved",
    "all future obligations are closed",
    "coercivity is proved",
    "analytic bridge is proved",
]:
    if re.search(re.escape(overclaim), text, flags=re.IGNORECASE):
        raise SystemExit(f"BOUNDARY := forbidden overclaim phrase present: {overclaim}")

import_line = "import URF.Frontier.ArithmeticSpectralCoercivityFireX"
if import_line not in urf_text.splitlines():
    raise SystemExit("MISSING_OBJECT := import URF.Frontier.ArithmeticSpectralCoercivityFireX")

print("ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_OK")
