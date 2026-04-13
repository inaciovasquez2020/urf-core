from pathlib import Path

def test_dragon_canonical_placement():
    text = Path("docs/foundations/DRAG0N.md").read_text(encoding="utf-8")
    assert "# DraG0n" in text
    assert "## Status" in text
    assert "CANONICAL" in text
    assert "Cross-program meta-framework rather than problem-specific frontier math." in text
    assert "The canonical home of DraG0n is `urf-core/docs/foundations/DRAG0N.md`." in text
    assert "Mirror only in `urf-textbook` for exposition." in text
    assert "- `chronos-urf-rr`" in text
    assert "- `clay-problem-lab`" in text
    assert "- `ym-os-quantization`" in text
    assert "- `pachner-invariant`" in text
