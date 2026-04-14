from pathlib import Path

def test_star_remaining_frontier_order():
    text = Path("docs/math/STAR_MINIMAL_MISSING_PACKAGE.md").read_text(encoding="utf-8")
    assert "# Star Minimal Missing Package" in text
    assert "Conditional." in text
    assert "R3 \\prec (R1A+R1B) \\prec R2 \\prec R6 \\prec R5 \\prec R8 \\prec R4." in text
    assert "\\textbf{R3.}" in text
    assert "\\textbf{R1A.}" in text
    assert "\\textbf{R1B.}" in text
    assert "\\textbf{R2.}" in text
    assert "\\textbf{R6.}" in text
    assert "\\textbf{R5.}" in text
    assert "\\textbf{R8.}" in text
    assert "\\textbf{R4.}" in text
    assert "Terminal unresolved theorem-replacement object: DraG0n Completeness." in text
