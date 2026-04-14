from pathlib import Path

def test_remaining_math_closure_lock():
    text = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\text{Spectral separation}=\\text{open}" in text
    assert "\\text{Measure-cycle coercivity}=\\text{open}" in text
    assert "\\text{Global coercivity}=\\text{conditional}" in text
