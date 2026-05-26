from pathlib import Path

LEAN = Path("lean/URF/DescentSystem.lean")
STATUS = Path("docs/status/URF_DESCENT_FIRST_REMAINING_ADMIT_ASSUMPTION_THEOREM_CLOSURE_2026_05_26.md")


def test_descent_first_remaining_admit_assumption_is_theorem_not_axiom():
    text = LEAN.read_text()
    assert "theorem descent_first_remaining_admit_assumption_2026_05_15 : True := by" in text
    assert "axiom descent_first_remaining_admit_assumption_2026_05_15 : True" not in text


def test_descent_first_remaining_admit_assumption_boundary_doc_exists():
    text = STATUS.read_text()
    assert "THEOREM_CLOSED_TRIVIAL_TRUE_SURFACE" in text
    assert "does not prove a descent theorem" in text
    assert "does not prove termination" in text
    assert "does not prove monotonicity" in text
    assert "does not prove unrestricted Chronos-RR" in text
    assert "does not prove P vs NP" in text
    assert "does not prove any Clay problem" in text
