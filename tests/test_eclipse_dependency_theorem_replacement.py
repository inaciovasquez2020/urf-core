from pathlib import Path

def test_eclipse_dependency_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_DEPENDENCY_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "DependencyClosed" in text
    assert "\\operatorname{DependencyInvariant}_A" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
