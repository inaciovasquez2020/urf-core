from pathlib import Path

def test_dragon_explicit_admissibility_axioms_lock():
    text = Path("docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md").read_text(encoding="utf-8")
    assert "# DraG0n Explicit Admissibility Axioms" in text
    assert "CONDITIONAL" in text
    assert "Axiom A1: Finite wall alphabet" in text
    assert "Axiom A2: Budget bound" in text
    assert "Axiom A3: Finite partition data" in text
    assert "Axiom A4: Quantized score image" in text
    assert "Axiom A5: Quotient compatibility" in text
    assert "\\mathcal M_{\\mathrm{aug}}^{(k)}(D)/{\\equiv}" in text

def test_dragon_finite_quotient_from_explicit_axioms_lock():
    text = Path("docs/math/DRAGON_FINITE_QUOTIENT_FROM_EXPLICIT_AXIOMS.md").read_text(encoding="utf-8")
    assert "# DraG0n Finite Quotient from Explicit Admissibility Axioms" in text
    assert "CONDITIONAL ON `DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS`" in text
    assert "By A1 and A2, only finitely many primitive wall selections may occur." in text
    assert "By A5, an `\\equiv`-class is determined by score value together with partition datum." in text

def test_dragon_foundation_points_to_explicit_route():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "## Explicit finiteness route" in text
    assert "`docs/math/DRAGON_EXPLICIT_ADMISSIBILITY_AXIOMS.md`" in text
    assert "`docs/math/DRAGON_FINITE_QUOTIENT_FROM_EXPLICIT_AXIOMS.md`" in text
