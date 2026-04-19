from pathlib import Path

def test_spectral_rigidity_final_wall_lock() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_FINAL_WALL.md").read_text()
    assert "Status: OPEN." in s
    assert r"\ker(\iota)=\{0\}" in s
    assert r"\mathcal P(w)\Longrightarrow \mathcal P(\iota(w))" in s
    assert "Unconditional spectral-rigidity completion is admissible only after both statements above are proved." in s
    assert "This note does not claim that the statements above have been proved." in s
