from pathlib import Path

def test_single_active_frontier_policy_2026_04_literal() -> None:
    policy = Path("docs/status/SINGLE_ACTIVE_FRONTIER_POLICY_2026_04.md").read_text(encoding="utf-8")
    pointer = Path("docs/status/ACTIVE_FRONTIER_POINTER_2026_04.md").read_text(encoding="utf-8")
    token = "AKCL_SIMULATED_TO_GENUINE_IDENTIFICATION_OPEN_PROBLEM_2026_04.md"

    assert token in policy
    assert token in pointer
    assert "No additional theorem-level frontier" in policy
