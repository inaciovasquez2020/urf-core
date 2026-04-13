from pathlib import Path

def test_dragon_representation_invariant_minimal_augmentation():
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
    assert "## DraG0n* weakest sufficient missing theorem" in text
    assert "### Representation-Invariant Minimal Augmentation Theorem" in text
    assert "D \\sim D' \\implies \\widehat{\\mathcal C}(D)=\\widehat{\\mathcal C}(D')." in text
    assert "well-defined on equivalence classes" in text
