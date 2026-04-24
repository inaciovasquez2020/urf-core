from pathlib import Path

DOC = Path("docs/status/SINGLE_ACTIVE_FRONTIER_AUDIT_2026_04_24.md").read_text()

def test_single_active_frontier_audit_is_status_only():
    assert "Status: AUDIT LOCK." in DOC
    assert "make urf-style" in DOC
    assert "8 passed" in DOC
    assert "AKCL_SIMULATED_TO_GENUINE_IDENTIFICATION_OPEN_PROBLEM_2026_04.md" in DOC
    assert "does not prove any new theorem" in DOC
    assert "does not claim" in DOC
    assert "zero axioms across the entire repository" in DOC
    assert "No theorem-level closure is claimed" in DOC
