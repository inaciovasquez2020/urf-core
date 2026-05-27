import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "finite_local_urf3_globalization_bridge.lean"
ART = ROOT / "artifacts/urf/finite_local_urf3_globalization_bridge_2026_05_27.json"
DOC = ROOT / "docs/status/FINITE_LOCAL_URF3_GLOBALIZATION_BRIDGE_2026_05_27.md"

def test_lean_contains_closed_chain():
    text = LEAN.read_text()
    for token in [
        "theorem FiniteLocalDataToCompleteURF3Package",
        "theorem FiniteLocalDataToFiniteLocalURF3Bound",
        "theorem LocalFiniteURF3ToGlobalURF3Bound",
        "theorem UnrestrictedURF3_from_globalization_bridge",
        "theorem AdmissibleGlobalURF3",
        "theorem no_universal_UnrestrictedURF3GlobalizationBridge",
        "¬ Nonempty",
    ]:
        assert token in text

def test_counterexample_is_constant_two():
    text = LEAN.read_text()
    assert "badGlobalCMI : ℕ → ℝ := fun _ => 2" in text
    assert "norm_num [badGlobalCMI] at hbad" in text

def test_artifact_status_and_boundaries():
    data = json.loads(ART.read_text())
    assert data["status"] == "FINITE_LOCAL_AND_ADMISSIBLE_GLOBAL_CLOSED_UNIVERSAL_REFUTED"
    required = {
        "unrestricted arbitrary-global URF Law 3",
        "unrestricted Chronos-RR",
        "unrestricted H4.1/FGL",
        "P vs NP",
        "any Clay problem",
    }
    assert required.issubset(set(data["does_not_prove"]))

def test_doc_records_boundary():
    text = DOC.read_text()
    assert "finite/local and admissible-global only" in text
    assert "unrestricted arbitrary-global URF Law 3" in text
    assert "fun _ => 2" in text
