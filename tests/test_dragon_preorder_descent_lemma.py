from pathlib import Path

def test_dragon_preorder_descent_lemma_lock():
    text = Path("docs/math/DRAGON_PREORDER_DESCENT_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Preorder Descent Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text
    assert "[(Z,\\pi)]\\preceq_{\\equiv}[(Z',\\pi')]" in text
    assert "well-defined preorder" in text

def test_dragon_finite_quotient_points_to_preorder_descent():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_ADMISSIBILITY_LEMMA.md").read_text(encoding="utf-8")
    assert "`docs/math/DRAGON_PREORDER_DESCENT_LEMMA.md`" in text

def test_dragon_foundation_updates_next_objects_after_transport():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "1. Prove quotient descent of `\\preceq`." in text
    assert "4. Derive unconditional representation-invariant minimal augmentation." in text
