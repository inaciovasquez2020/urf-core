import json
from pathlib import Path

artifact = Path("artifacts/urf/theorem_closure_classifier_external_reference_2026_06_05.json")
data = json.loads(artifact.read_text())

assert data["status"] == "EXTERNAL_METHOD_REFERENCE_ONLY"
assert data["version"] == "v0.1.1"
assert data["verification"]["pytest"] == "8 passed"
assert data["verification"]["control_suite"] == "7 / 7 controls pass"
assert data["boundary"]["method_artifact_only"] is True
assert data["boundary"]["new_theorem_claim"] is False
assert data["boundary"]["benchmark_theorems_reproved"] is False
assert data["boundary"]["zenodo_doi_recorded"] is False

print("THEOREM_CLOSURE_CLASSIFIER_EXTERNAL_REFERENCE_OK")
