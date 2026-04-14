from pathlib import Path

def test_eclipse_forward_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_FORWARD_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "\\operatorname{Eclipse}" in text
    assert "\\operatorname{ExternalReproducible}" in text
    assert "\\operatorname{AuditStable}" in text
    assert "\\operatorname{DependencyClosed}" in text
    assert "\\operatorname{StatusTruthful}" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
