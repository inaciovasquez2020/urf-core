from pathlib import Path

def test_eclipse_bridge_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_BRIDGE_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "AuditStable" in text
    assert "StatusTruthful" in text
    assert "\\operatorname{StatusInvariant}_A" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
