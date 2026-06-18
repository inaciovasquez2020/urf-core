from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
lean_path = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityFireXSupplyRuleSource.lean"
urf_path = ROOT / "lean" / "URF.lean"

if not lean_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF/Frontier/ArithmeticSpectralCoercivityFireXSupplyRuleSource.lean")
if not urf_path.exists():
    raise SystemExit("MISSING_OBJECT := lean/URF.lean")

text = lean_path.read_text()
urf_text = urf_path.read_text()

required_fragments = [
    "import URF.Frontier.ArithmeticSpectralCoercivityFireX",
    "structure FireXSupplyRuleSource",
    "(B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)",
    "source :",
    "B.bridgeSuppliesInputHypothesisAssumption →",
    "B.input.arithmeticSpectralBridgeHypothesis",
    "def FireX.ofSupplyRuleSource",
    "(S : FireXSupplyRuleSource B)",
    "FireX B where",
    "suppliesInputHypothesis := S.source",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_RECORDED : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_ONLY : Bool := true",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_ANALYTIC_BRIDGE_CLOSED : Bool := false",
    "def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_FINAL_CLOSURE_CLAIMED : Bool := false",
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

for forbidden_claim in [
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_ANALYTIC_BRIDGE_CLOSED : Bool := true",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_FINAL_CLOSURE_CLAIMED : Bool := true",
]:
    if forbidden_claim in text:
        raise SystemExit(f"BOUNDARY := forbidden closure claim present: {forbidden_claim}")

import_line = "import URF.Frontier.ArithmeticSpectralCoercivityFireXSupplyRuleSource"
if import_line not in urf_text.splitlines():
    raise SystemExit("MISSING_OBJECT := import URF.Frontier.ArithmeticSpectralCoercivityFireXSupplyRuleSource")

print("ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_OK")
