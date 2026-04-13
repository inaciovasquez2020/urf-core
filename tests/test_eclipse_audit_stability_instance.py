from pathlib import Path

def test_eclipse_audit_stability_instance_lock():
    text = Path("docs/math/ECLIPSE_AUDIT_STABILITY_INSTANCE.md").read_text(encoding="utf-8")
    assert "# Eclipse Audit Stability Instance" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Instance" in text
    assert "## Target" in text
    assert "## Certification form" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{AuditStable}(\\mathcal P_0)" in text
    assert "H(\\mathcal P_0)\\vdash (K_0,S_0,D_0,W_0)" in text
    assert "\\operatorname{CoreClaims}(H(\\mathcal P_0))=K_0" in text
    assert "\\operatorname{StatusMap}(H(\\mathcal P_0))=S_0" in text
    assert "\\operatorname{DependencyGraph}(H(\\mathcal P_0))=D_0" in text
    assert "\\operatorname{WitnessSet}(H(\\mathcal P_0))=W_0" in text
