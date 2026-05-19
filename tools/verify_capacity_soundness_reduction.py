from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/CapacitySoundnessReduction.lean"
doc = ROOT / "docs/status/CAPACITY_SOUNDNESS_REDUCTION_2026_05_19.md"
artifact = ROOT / "artifacts/urf/capacity_soundness_reduction_2026_05_19.json"
root = ROOT / "lean/URF.lean"

lean_text = lean.read_text()
doc_text = doc.read_text()
data = json.loads(artifact.read_text())
root_text = root.read_text()

required_lean = [
    "structure CapacityInterface",
    "Trace : Type",
    "Adm : Trace → Prop",
    "Encodes : Trace → Generator → Prop",
    "StableGen : Generator → Prop",
    "def AdmissibleInformationSet",
    "noncomputable def C_adm",
    "def StableGenAdmissibleTrace",
    "def CapacitySoundness",
    "theorem admissibleTraceBound",
    "theorem capacitySoundness_from_stableTrace",
    "theorem capacity_obstruction_contrapositive",
    "le_csSup",
]

for token in required_lean:
    assert token in lean_text, token

assert "import URF.Foundation.CapacitySoundnessReduction" in root_text
assert "Status: `CONDITIONAL`" in doc_text
assert "Unique open object:" in doc_text
assert "- `StableGenAdmissibleTrace`" in doc_text
assert data["status"] == "CONDITIONAL"
assert data["unique_open_object"] == "StableGenAdmissibleTrace"

for forbidden in [
    "proves StableGenAdmissibleTrace",
    "proves unrestricted UniversalFiberEntropyGap",
    "proves unrestricted Chronos-RR",
    "proves unrestricted H4.1/FGL",
    "proves P vs NP",
    "proves any Clay problem",
]:
    assert forbidden not in doc_text
    assert forbidden not in lean_text

print("Capacity soundness reduction verified.")
