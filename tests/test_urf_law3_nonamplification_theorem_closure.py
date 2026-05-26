from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LAW3 = ROOT / "urf_law3.lean"
DOC = ROOT / "docs/status/URF_LAW3_NONAMPLIFICATION_THEOREM_CLOSURE_2026_05_26.md"

def test_urf_law3_has_no_local_admit_or_sorry():
    text = LAW3.read_text()
    assert "theorem urf_law3" in text
    assert "Finset.single_le_sum" in text
    assert "le_trans hterm_le_sum hsum_le_one" in text
    assert "admit" not in text
    assert "sorry" not in text

def test_boundary_is_assumption_backed_not_unconditional():
    text = DOC.read_text()
    assert "ASSUMPTION_BACKED_THEOREM_CLOSURE_ONLY" in text
    assert "capacity" in text
    assert "chain_rule" in text
    assert "cmi_nonneg" in text
    assert "full URF-core load-bearing theorem closure" in text
    assert "P vs NP" in text
    assert "any Clay problem" in text
