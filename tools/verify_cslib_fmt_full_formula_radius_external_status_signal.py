#!/usr/bin/env python3
from pathlib import Path
import json

artifact_path = Path("artifacts/cslib_fmt/full_formula_radius_external_status_signal_2026_06_21.json")
doc_path = Path("docs/status/CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL.md")

data = json.loads(artifact_path.read_text())
doc = doc_path.read_text()

assert data["status"] == "CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL"
assert data["source_repo"] == "https://github.com/inaciovasquez2020/cslib-fmt"
assert data["source_repo_role"] == "external_formal_infrastructure_source"

commits = data["source_commits"]
assert commits["full_formula_radius_construction"] == "e352dfa"
assert commits["downstream_old_boundary_audit"] == "936a562"
assert commits["historical_boundary_supersession_notes"] == "08eb890"

assert "full_formula_radius_construction" in data["source_objects"]
assert "full_formula_radius_construction_closed" in data["source_objects"]
assert "full_formula_radius_historical_boundary_supersession_notes" in data["source_objects"]

validation = data["source_validation"]
assert validation["lean_check"] == "passed"
assert validation["full_formula_radius_construction_verifier"] == "FULL_FORMULA_RADIUS_CONSTRUCTION_OK"
assert validation["downstream_old_boundary_audit_verifier"] == "FULL_FORMULA_RADIUS_DOWNSTREAM_OLD_BOUNDARY_AUDIT_OK"
assert validation["historical_boundary_supersession_notes_verifier"] == "FULL_FORMULA_RADIUS_HISTORICAL_BOUNDARY_SUPERSESSION_NOTES_OK"
assert validation["noncomputable_audit"] == "NONCOMPUTABLE_AUDIT_OK"
assert validation["pytest"] == "230 passed"

assert data["urf_core_effect"] == "status_signal_only"
assert "Lean proof object from cslib-fmt" in data["does_not_import"]
assert "URF core theorem closure" in data["does_not_import"]
assert "URF maturity upgrade" in data["does_not_import"]
assert "external status signal only" in data["boundary"]
assert "no cross-repo proof import" in data["boundary"]
assert "no URF-core theorem status change" in data["boundary"]

assert "Status: `CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL`" in doc
assert "`e352dfa`" in doc
assert "`936a562`" in doc
assert "`08eb890`" in doc
assert "status signal only" in doc
assert "does not import a Lean proof object" in doc
assert "no URF-core theorem status change" in doc

print("CSLIB_FMT_FULL_FORMULA_RADIUS_EXTERNAL_STATUS_SIGNAL_OK")
