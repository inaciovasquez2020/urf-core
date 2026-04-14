from pathlib import Path

def test_eclipse_reconstruction_theorem_replacement_lock() -> None:
    path = Path("docs/math/ECLIPSE_RECONSTRUCTION_THEOREM_REPLACEMENT.md")
    text = path.read_text(encoding="utf-8")
    assert "ExternalReproducible" in text
    assert "\\operatorname{ReconstructionStable}_A" in text
    assert "\\Rightarrow" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
