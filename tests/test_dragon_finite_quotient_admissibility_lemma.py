from pathlib import Path

def test_dragon_finite_quotient_admissibility_lemma_lock():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Quotient Admissibility Lemma" in text
    assert "## Status" in text
    assert "CONDITIONAL" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text
    assert "\\preceq" in text
    assert "\\widehat{\\mathcal C}(D\\mid Z,\\pi)" in text
    assert "D \\sim D'" in text
    assert "has a `\\preceq`-minimal element" in text

def test_dragon_foundation_points_to_frontier():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "## Augmentation equivalence" in text
    assert "(Z,\\pi)\\equiv(Z',\\pi')" in text
    assert "The weakest remaining theorem object is `docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md`." in text

def test_dragon_unconditional_corollary_lock():
    text = Path("docs/math/DRAGON_RIMAT_UNCONDITIONAL_COROLLARY.md").read_text(encoding="utf-8")
    assert "# DraG0n Representation-Invariant Minimal Augmentation Theorem: Unconditional Corollary" in text
    assert "CONDITIONAL ON `DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA`" in text
    assert "\\widehat{\\mathrm{DraG0n}}^{(k)}(D)=1" in text
    assert "invariant under diagnostic equivalence `D\\sim D'`" in text
