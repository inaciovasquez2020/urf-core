from pathlib import Path

def test_local_cycle_rank_bound_lock():
    text = Path("docs/math/LOCAL_CYCLE_RANK_BOUND.md").read_text(encoding="utf-8")
    assert "LCR}(k,\\Delta,R_0)" in text
    assert "rank" in text
    assert "Status: OPEN." in text
