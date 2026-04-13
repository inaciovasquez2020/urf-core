from pathlib import Path

def test_eclipse_canonical_placement():
    text = Path("docs/foundations/ECLIPSE.md").read_text(encoding="utf-8")
    assert "# Eclipse" in text
    assert "## Canonical placement" in text
    assert "`urf-core/docs/foundations/ECLIPSE.md`" in text
    assert "Cross-program meta-framework layer." in text
    assert "Mirror only in `urf-textbook` for exposition." in text
    assert "`chronos-urf-rr`" in text
    assert "`clay-problem-lab`" in text
    assert "`ym-os-quantization`" in text
    assert "`pachner-invariant`" in text
