from pathlib import Path

def test_eclipse_concrete_assembly_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_CONCRETE_ASSEMBLY_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "\\operatorname{ReconstructionStable}_A" in text
    assert "\\operatorname{StatusInvariant}_A" in text
    assert "\\operatorname{DependencyInvariant}_A" in text
    assert "\\operatorname{Eclipse}" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
