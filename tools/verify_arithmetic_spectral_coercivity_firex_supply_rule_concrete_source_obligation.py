from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN_FILE = ROOT / "lean" / "URF" / "Frontier" / "ArithmeticSpectralCoercivityFireXSupplyRuleConcreteSourceObligation.lean"
IMPORT_FILE = ROOT / "lean" / "URF.lean"

lean_text = LEAN_FILE.read_text()
import_text = IMPORT_FILE.read_text()

required_lean_markers = [
    "structure FireXSupplyRuleConcreteSourceObligation",
    "def FireXSupplyRuleSource.ofConcreteSourceObligation",
    "theorem fireXSupplyRuleConcreteSourceObligation_supplies_inputHypothesis_conditional",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_RECORDED",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_ONLY",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_ANALYTIC_BRIDGE_CLOSED",
    "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_FINAL_COERCIVITY_CLOSED",
    "Bool := false",
]

required_import_markers = [
    "import URF.Frontier.ArithmeticSpectralCoercivityFireXSupplyRuleConcreteSourceObligation",
]

missing = [
    marker for marker in required_lean_markers
    if marker not in lean_text
] + [
    marker for marker in required_import_markers
    if marker not in import_text
]

if missing:
    raise SystemExit("MISSING_MARKERS := " + ", ".join(missing))

print("ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_OK")
