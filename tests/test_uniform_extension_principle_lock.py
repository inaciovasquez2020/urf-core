from pathlib import Path

def test_uniform_extension_principle_lock():
    uep = Path("docs/math/UNIFORM_EXTENSION_PRINCIPLE.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{UEP}" in uep
    assert "\\text{Frontier status}=\\text{open}." in uep
    assert "\\widehat{\\lambda}_{\\mathrm{sep}}^{\\mathcal B}" in uep
    assert "\\lambda_{\\mathrm{sep}}" in uep
    assert "\\mathbf{UEP}" in rm
    assert "\\mathbf{UEP}\\Rightarrow \\mathbf{TBA}" in rm
