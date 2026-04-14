from pathlib import Path

def test_global_coercivity_implies_unconditional_closure_lock():
    text = Path("docs/math/GLOBAL_COERCIVITY_IMPLIES_UNCONDITIONAL_CLOSURE.md").read_text(encoding="utf-8")
    assert "Global Coercivity\\Longrightarrow \\text{Unconditional Closure}" in text
    assert "Status: OPEN." in text
    assert "\\Phi(x)\\ge \\gamma" in text
    assert "Witness" in text and "TheoremCert" in text
