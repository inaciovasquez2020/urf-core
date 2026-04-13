from pathlib import Path

def test_eclipse_concrete_assembly_lock():
    text = Path("docs/math/ECLIPSE_CONCRETE_ASSEMBLY.md").read_text(encoding="utf-8")
    assert "# Eclipse Concrete Assembly" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Inputs" in text
    assert "## Reduction" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ReconstructionStable}_A(\\mathcal P_0)" in text
    assert "\\operatorname{StatusInvariant}_A(\\mathcal P_0)" in text
    assert "\\operatorname{DependencyInvariant}_A(\\mathcal P_0)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)." in text
    assert "\\operatorname{CoreClaims}(a(\\mathcal P_0))=K_0." in text
    assert "\\operatorname{StatusMap}(a(\\mathcal P_0))=S_0." in text
    assert "\\operatorname{DependencyGraph}(a(\\mathcal P_0))\\cong D_0." in text
    assert "a(\\mathcal P_0)\\cong \\mathcal P_0." in text
