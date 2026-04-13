from pathlib import Path

def test_eclipse_external_reproducibility_instance_lock():
    text = Path("docs/math/ECLIPSE_EXTERNAL_REPRODUCIBILITY_INSTANCE.md").read_text(encoding="utf-8")
    assert "# Eclipse External Reproducibility Instance" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Instance" in text
    assert "## Target" in text
    assert "## Certification form" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ExternalReproducible}(\\mathcal P_0)" in text
    assert "R(W_0)=(K_0,S_0,D_0)" in text
    assert "\\operatorname{CoreClaims}(R(W_0))=K_0" in text
    assert "\\operatorname{StatusMap}(R(W_0))=S_0" in text
    assert "\\operatorname{DependencyGraph}(R(W_0))=D_0" in text
