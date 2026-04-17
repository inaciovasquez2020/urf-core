from pathlib import Path

def test_urf_remaining_frontier_canonical_doc():
    p = Path("docs/status/URF_REMAINING_FRONTIER_CANONICAL.md")
    s = p.read_text()
    assert "# URF Remaining Frontier — Canonical" in s
    assert "Status: CANONICAL" in s
    assert "The only remaining whole-URF public-facing residual is the unresolved unconditional witness-family mathematics boundary referenced by executable descendants." in s
    assert "All whole-URF public-facing residual-frontier references must point to this file." in s
    assert "No public-facing whole-URF statement may claim stronger status than this file." in s
