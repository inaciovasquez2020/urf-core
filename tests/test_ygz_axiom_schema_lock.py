from pathlib import Path

def test_ygz_axiom_schema_lock() -> None:
    s = Path("docs/math/YGZ_SPECTRAL_RIGIDITY_PACKAGE.md").read_text()
    assert "## Axioms" in s
    assert r"\textbf{A.}" in s
    assert r"\mathfrak I(w)=0\iff w=0" in s
    assert r"\textbf{B.}" in s
    assert r"\iota(w)=0\Longrightarrow \mathfrak I(w)=0" in s
    assert r"\textbf{C.}" in s
    assert r"\mathcal P(w)\Longrightarrow \mathcal P(\iota(w))" in s
    assert "Conditional completion is admissible only under A+B+C." in s

def test_final_wall_conditional_deduction_lock() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_FINAL_WALL.md").read_text()
    assert "## Conditional deduction" in s
    assert "YGZ_SPECTRAL_RIGIDITY_PACKAGE.md" in s
    assert r"\ker(\iota)=\{0\}" in s
    assert r"\mathcal P(w)\Longrightarrow \mathcal P(\iota(w))" in s
    assert "Conditional completion is admissible under A+B+C." in s
