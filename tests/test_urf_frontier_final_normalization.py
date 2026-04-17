from pathlib import Path

def test_urf_frontier_final_normalization():
    s = Path("docs/status/URF_REMAINING_FRONTIER_CANONICAL.md").read_text()
    assert "URF residual frontier" in s
    assert "Status: CANONICAL" in s
