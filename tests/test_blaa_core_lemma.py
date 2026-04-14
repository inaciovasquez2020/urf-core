from pathlib import Path

def test_blaa_core_lemma_lock():
    text = Path("docs/math/BLAA_CORE_LEMMA.md").read_text(encoding="utf-8")
    assert "Sector-Deletion Preservation Lemma" in text
    assert "AdmWitness" in text
    assert "\\mathsf{size}(\\Psi_{y}(W))<\\mathsf{size}(W)" in text
    assert "Global Coercivity" in text
