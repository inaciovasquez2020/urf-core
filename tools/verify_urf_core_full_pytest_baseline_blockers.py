#!/usr/bin/env python3
from pathlib import Path
import json

artifact_path = Path("artifacts/urf/full_pytest_baseline_blockers_2026_06_21.json")
doc_path = Path("docs/status/URF_CORE_FULL_PYTEST_BASELINE_BLOCKERS_2026_06_21.md")
signal_artifact = Path("artifacts/cslib_fmt/full_formula_radius_external_status_signal_2026_06_21.json")
signal_tool = Path("tools/verify_cslib_fmt_full_formula_radius_external_status_signal.py")
signal_test = Path("tests/test_cslib_fmt_full_formula_radius_external_status_signal.py")

data = json.loads(artifact_path.read_text())
doc = doc_path.read_text()

assert data["status"] == "URF_CORE_FULL_PYTEST_BASELINE_BLOCKERS_2026_06_21"
assert data["baseline_commit"] == "b02b6a9"
assert data["signal_status"] == "CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL_OK"
assert data["signal_effect"] == "status_signal_only"
assert data["full_pytest_observed"]["result"] == "failed"
assert data["full_pytest_observed"]["expected_failure_count"] == 7
assert "7 failed" in data["full_pytest_observed"]["summary_marker"]
assert len(data["full_pytest_observed"]["expected_failures"]) == 7

assert signal_artifact.exists()
assert signal_tool.exists()
assert signal_test.exists()

assert "Status: `URF_CORE_FULL_PYTEST_BASELINE_BLOCKERS_2026_06_21`" in doc
assert "CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL_OK" in doc
assert "7 failed, 415 passed, 11 subtests passed" in doc
assert "baseline-blocker inventory only" in data["boundary"]
assert "no cross-repo proof import" in doc

for failure in data["full_pytest_observed"]["expected_failures"]:
    assert failure in doc

print("URF_CORE_FULL_PYTEST_BASELINE_BLOCKERS_OK")
