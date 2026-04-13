from pathlib import Path

def test_eclipse_assembly_frontier_lock():
    text = Path("docs/math/ECLIPSE_ASSEMBLY_FRONTIER.md").read_text(encoding="utf-8")
    assert "# Eclipse Assembly Frontier" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Definitions" in text
    assert "## Assembly schema" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ReconstructionStable}_A(\\mathcal P)" in text
    assert "\\operatorname{StatusInvariant}_A(\\mathcal P)" in text
    assert "\\operatorname{DependencyInvariant}_A(\\mathcal P)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P)" in text
