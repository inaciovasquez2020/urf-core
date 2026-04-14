from pathlib import Path

def test_measure_cycle_to_lcrb_lock():
    text = Path("docs/math/MEASURE_CYCLE_TO_LOCAL_CYCLE_RANK_BOUND.md").read_text(encoding="utf-8")
    assert "\\mathbf{MC}\\Rightarrow \\mathbf{LCRB}" in text
    assert "\\text{Reduction status}=\\text{locked}." in text
    assert "\\text{Proof status}=\\text{conditional" in text
