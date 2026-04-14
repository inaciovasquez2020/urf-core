from pathlib import Path

def test_theorem_bridge_axiom_lock():
    tba = Path("docs/math/THEOREM_BRIDGE_AXIOM.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{TBA}" in tba
    assert "\\text{Frontier status}=\\text{open}." in tba
    assert "\\widehat{\\lambda}_{\\mathrm{sep}}^{\\mathcal B}" in tba
    assert "\\lambda_{\\mathrm{sep}}" in tba
    assert "\\mathbf{TBA}" in rm
