from pathlib import Path

def test_dragon_finite_score_image_lemma_lock():
    text = Path("docs/math/DRAGON_FINITE_SCORE_IMAGE_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Score Image Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\operatorname{Clust},\\operatorname{Stab},\\operatorname{Mask},\\operatorname{Block}" in text
    assert "\\mathfrak C_D^{(k)}" in text
    assert "This isolates A4 of `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md` as a standalone theorem object." in text

def test_dragon_explicit_axioms_point_to_score_image_lemma():
    text = Path("docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md").read_text(encoding="utf-8")
    assert "Current standalone route: `docs/math/DRAGON_FINITE_SCORE_IMAGE_LEMMA.md`." in text
