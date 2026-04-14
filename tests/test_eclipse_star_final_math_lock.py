from pathlib import Path

def test_eclipse_star_final_math_lock():
    text = Path("docs/math/ECLIPSE_STAR_FINAL_REMAINING_MATH.md").read_text()

    assert "Final Remaining Frontier Package" in text
    assert "R2 \\prec R6 \\prec R5 \\prec R8." in text

    assert "Entropy–Energy Domination" in text
    assert "Collapse Regularity" in text
    assert "Phase Boundary Rigidity" in text
    assert "Capacity Bound" in text

    assert "\\text{Unconditional Eclipse equivalence}=\\text{not proved}." in text
