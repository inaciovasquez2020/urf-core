from pathlib import Path

def test_terminal_theorem_objects_lock():
    ss = Path("docs/math/FINITE_TYPE_SPECTRAL_SEPARATION.md").read_text(encoding="utf-8")
    mc = Path("docs/math/MEASURE_CYCLE_COERCIVITY.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{SS}" in ss
    assert "\\text{Frontier status}=\\text{open}." in ss
    assert "\\mathbf{MC}" in mc
    assert "\\text{Frontier status}=\\text{open}." in mc
    assert "\\mathbf{SS}=\\text{Finite-type spectral separation}" in rm
    assert "\\mathbf{MC}=\\text{Measure-cycle coercivity}" in rm
    assert "(\\mathbf{SS}\\wedge \\mathbf{MC})\\Rightarrow \\text{Global coercivity}." in rm
