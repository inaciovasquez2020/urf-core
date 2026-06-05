import json
from pathlib import Path

def test_theorem_closure_classifier_external_reference_boundary():
    data = json.loads(Path("artifacts/urf/theorem_closure_classifier_external_reference_2026_06_05.json").read_text())
    assert data["status"] == "EXTERNAL_METHOD_REFERENCE_ONLY"
    assert data["boundary"]["new_theorem_claim"] is False
    assert data["boundary"]["benchmark_theorems_reproved"] is False
    assert data["boundary"]["zenodo_doi_recorded"] is False
