from pathlib import Path

def test_dragon_quotient_determinacy_lemma_lock():
    text = Path("docs/math/DRAGON_QUOTIENT_DETERMINACY_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Quotient Determinacy Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text
    assert "\\left(\\widehat{\\mathcal C}(D\\mid Z,\\pi),\\Pi_D(Z,\\pi)\\right)" in text
    assert "(Z,\\pi)\\equiv(Z',\\pi')" in text
    assert "\\mathfrak C_D^{(k)}\\times\\mathfrak P_D^{(k)}" in text

def test_dragon_finite_quotient_uses_determinacy_lemma():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_FROM_EXPLICIT_AXIOMS.md").read_text(encoding="utf-8")
    assert "`docs/math/DRAGON_QUOTIENT_DETERMINACY_LEMMA.md`" in text
