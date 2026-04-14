from pathlib import Path

def test_eclipse_extensionality_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_EXTENSIONALITY_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "\\operatorname{CoreClaims}" in text
    assert "\\operatorname{StatusMap}" in text
    assert "\\operatorname{DependencyGraph}" in text
    assert "\\operatorname{Eclipse}" in text
    assert "\\iff" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
