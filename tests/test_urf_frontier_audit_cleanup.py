from pathlib import Path

def test_urf_frontier_audit_cleanup():
    s = Path("docs/status/URF_REMAINING_FRONTIER_CANONICAL.md").read_text()
    assert "Status: CANONICAL" in s
    assert "URF public-facing residual frontier" in s
    assert "witness-family boundary" in s
