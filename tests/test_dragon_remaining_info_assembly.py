from pathlib import Path

def test_dragon_score_descent_lemma_lock():
    text = Path("docs/math/DRAGON_SCORE_DESCENT_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Score Descent Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\widehat{\\mathcal C}_{\\equiv}" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text
    assert "well-defined" in text

def test_dragon_finite_quotient_assembly_lock():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_ASSEMBLY.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Quotient Admissibility Assembly" in text
    assert "CONDITIONAL" in text
    assert "`docs/math/DRAGON_FINITE_WALL_ALPHABET_LEMMA.md`" in text
    assert "`docs/math/DRAGON_FINITE_PARTITION_IMAGE_LEMMA.md`" in text
    assert "`docs/math/DRAGON_FINITE_SCORE_IMAGE_LEMMA.md`" in text
    assert "`docs/math/DRAGON_QUOTIENT_DETERMINACY_LEMMA.md`" in text
    assert "`docs/math/DRAGON_TRANSPORT_UNDER_DIAGNOSTIC_EQUIVALENCE_LEMMA.md`" in text
    assert "`docs/math/DRAGON_PREORDER_DESCENT_LEMMA.md`" in text
    assert "`docs/math/DRAGON_SCORE_DESCENT_LEMMA.md`" in text
    assert "This assembles the full content of `docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md`." in text

def test_dragon_finite_quotient_points_to_score_descent_and_assembly():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md").read_text(encoding="utf-8")
    assert "`docs/math/DRAGON_SCORE_DESCENT_LEMMA.md`" in text
    assert "Current assembly route: `docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_ASSEMBLY.md`." in text

def test_dragon_foundation_updates_next_objects_after_preorder():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "1. Prove quotient descent of `\\widehat{\\mathcal C}`." in text
    assert "4. Specialize the axioms to target domains." in text
