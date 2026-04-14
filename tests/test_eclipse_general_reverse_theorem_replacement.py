from pathlib import Path

def test_eclipse_general_reverse_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_GENERAL_REVERSE_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "\\operatorname{ExternalReproducible}" in text
    assert "\\operatorname{AuditStable}" in text
    assert "\\operatorname{DependencyClosed}" in text
    assert "\\operatorname{StatusTruthful}" in text
    assert "\\operatorname{Eclipse}" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
