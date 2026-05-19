from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def test_capacity_soundness_reduction_lean_surface():
    text = (ROOT / "lean/URF/Foundation/CapacitySoundnessReduction.lean").read_text()
    assert "def StableGenAdmissibleTrace" in text
    assert "def CapacitySoundness" in text
    assert "theorem admissibleTraceBound" in text
    assert "theorem capacitySoundness_from_stableTrace" in text
    assert "theorem capacity_obstruction_contrapositive" in text
    assert "le_csSup" in text


def test_capacity_soundness_reduction_status_boundary():
    text = (ROOT / "docs/status/CAPACITY_SOUNDNESS_REDUCTION_2026_05_19.md").read_text()
    assert "Status: `CONDITIONAL`" in text
    assert "Unique open object:" in text
    assert "- `StableGenAdmissibleTrace`" in text
    assert "Does not prove:" in text
    assert "- `StableGenAdmissibleTrace`" in text
    assert "- unrestricted `UniversalFiberEntropyGap`" in text
    assert "- unrestricted Chronos-RR" in text
    assert "- unrestricted H4.1/FGL" in text
    assert "- P vs NP" in text
    assert "- any Clay problem" in text


def test_capacity_soundness_reduction_artifact():
    data = json.loads((ROOT / "artifacts/urf/capacity_soundness_reduction_2026_05_19.json").read_text())
    assert data["status"] == "CONDITIONAL"
    assert data["unique_open_object"] == "StableGenAdmissibleTrace"
    assert "CapacitySoundness" in data["closed_objects"]
    assert "StableGenAdmissibleTrace" in data["does_not_prove"]


def test_capacity_soundness_reduction_imported():
    text = (ROOT / "lean/URF.lean").read_text()
    assert "import URF.Foundation.CapacitySoundnessReduction" in text
