from pathlib import Path

def test_shadow_of_infinity_doc():
    p = Path("docs/foundations/SHADOW_OF_INFINITY.md")
    s = p.read_text()
    assert "Shadow of Infinity" in s
    assert "\\Sigma_\\infty" in s
    assert "\\mathsf A_{\\mathrm{fin}}" in s
    assert "Decision Rule" in s
