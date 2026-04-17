from pathlib import Path

def test_urf_core_points_to_canonical_frontier():
    found = False
    for rel in ["README.md", "docs/status/COMPLETION_SNAPSHOT_2026_04_10.md"]:
        p = Path(rel)
        if p.exists() and "docs/status/URF_REMAINING_FRONTIER_CANONICAL.md" in p.read_text():
            found = True
    assert found
