from pathlib import Path

def test_dragon_finite_partition_image_lemma_lock():
    text = Path("docs/math/DRAGON_FINITE_PARTITION_IMAGE_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Partition Image Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\Pi_D(Z,\\pi)" in text
    assert "\\mathfrak P_D^{(k)}" in text
    assert "use at most `k` primitive labels" in text
    assert "This isolates A3 of `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md` as a standalone theorem object." in text

def test_dragon_explicit_axioms_point_to_partition_image_lemma():
    text = Path("docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md").read_text(encoding="utf-8")
    assert "Current standalone route: `docs/math/DRAGON_FINITE_PARTITION_IMAGE_LEMMA.md`." in text
