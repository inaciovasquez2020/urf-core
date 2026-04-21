from pathlib import Path

def test_promotion_stability_law_literals():
    s = Path("docs/community/urf11/PROMOTION_STABILITY_LAW.md").read_text()
    assert "# URF-11 Promotion Stability Law" in s
    assert "## Status\nOPEN" in s
    assert "Promote(Pi_{i->j})=1" in s
    assert "no canonical theorem, dependency, or closure claim in urf-core is altered" in s
    assert "bridge metadata, benchmark evidence, acceptance witnesses, or routing references" in s
    assert "outside docs/community/urf11" in s
