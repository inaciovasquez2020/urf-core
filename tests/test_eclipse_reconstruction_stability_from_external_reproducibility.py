from pathlib import Path

def test_eclipse_reconstruction_stability_from_external_reproducibility_lock():
    text = Path("docs/math/ECLIPSE_RECONSTRUCTION_STABILITY_FROM_EXTERNAL_REPRODUCIBILITY.md").read_text(encoding="utf-8")
    assert "# Eclipse Reconstruction Stability from External Reproducibility" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Input" in text
    assert "## Reduction" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ExternalReproducible}(\\mathcal P_0)" in text
    assert "\\operatorname{ReconstructionStable}_A(\\mathcal P_0)." in text
    assert "\\forall R\\in\\mathcal R_A,\\quad" in text
    assert "R(W_0)=(K_0,S_0,D_0)." in text
    assert "factors through an admissible reconstruction" in text
    assert "R_a\\in\\mathcal R_A" in text
    assert "\\operatorname{CoreClaims}(a(\\mathcal P_0))=K_0." in text
    assert "\\operatorname{StatusMap}(a(\\mathcal P_0))=S_0." in text
    assert "\\operatorname{DependencyGraph}(a(\\mathcal P_0))\\cong D_0." in text
