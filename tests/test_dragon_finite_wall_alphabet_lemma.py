from pathlib import Path

def test_dragon_finite_wall_alphabet_lemma_lock():
    text = Path("docs/math/DRAGON_FINITE_WALL_ALPHABET_LEMMA.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Wall Alphabet Lemma" in text
    assert "CONDITIONAL" in text
    assert "\\Omega_D" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)" in text
    assert "use at most `k` primitive wall-types" in text
    assert "This isolates A1 and A2 of `docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md` as a standalone theorem object." in text

def test_dragon_explicit_axioms_point_to_wall_alphabet_lemma():
    text = Path("docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md").read_text(encoding="utf-8")
    assert "Current standalone route: `docs/math/DRAGON_FINITE_WALL_ALPHABET_LEMMA.md`." in text
