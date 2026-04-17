from pathlib import Path

def test_urf_frontier_lock_final():
    s = Path("docs/status/URF_REMAINING_FRONTIER_CANONICAL.md").read_text()
    assert "Status: CANONICAL" in s
    assert "URF residual frontier" in s
    assert "Scope:" not in s
