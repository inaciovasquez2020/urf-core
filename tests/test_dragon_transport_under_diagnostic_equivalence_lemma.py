from pathlib import Path

def test_dragon_transport_under_diagnostic_equivalence_lemma_lock():
    text = Path("docs/math/DRAGON_TRANSPORT_UNDER_DIAGNOSTIC_EQUIVALENCE_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Transport Under Diagnostic Equivalence Lemma" in text
    assert "CONDITIONAL" in text
    assert "D\\sim D'" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D')/{\\equiv}" in text
    assert "which is bijective and preserves:" in text
    assert "the preorder `\\preceq`" in text
    assert "the score value `\\widehat{\\mathcal C}`" in text
    assert "the induced partition datum `\\Pi_D`" in text

def test_dragon_finite_quotient_points_to_transport_lemma():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md").read_text(encoding="utf-8")
    assert "`docs/math/DRAGON_TRANSPORT_UNDER_DIAGNOSTIC_EQUIVALENCE_LEMMA.md`" in text

def test_dragon_foundation_reorders_next_theorem_objects():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "1. Prove quotient descent of `\\widehat{\\mathcal C}`." in text
    assert "3. Derive unconditional representation-invariant minimal augmentation." in text
