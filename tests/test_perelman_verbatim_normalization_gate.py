from pathlib import Path

def test_perelman_verbatim_normalization_gate():
    text = Path("docs/math/PERELMAN_VERBATIM_NORMALIZATION_GATE.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\mathrm{PL\mbox{-}0001}" in text
    assert r"\mathrm{PL\mbox{-}0006}" in text
    assert "verbatim_source_excerpt" in text
    assert "normalized_statement" in text
    assert "normalization_notes" in text
    assert "internally_verified" in text
