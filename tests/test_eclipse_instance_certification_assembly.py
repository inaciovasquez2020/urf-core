from pathlib import Path

def test_eclipse_instance_certification_assembly_lock():
    text = Path("docs/math/ECLIPSE_INSTANCE_CERTIFICATION_ASSEMBLY.md").read_text(encoding="utf-8")
    assert "# Eclipse Instance Certification Assembly" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Input obligations" in text
    assert "ECLIPSE_EXTERNAL_REPRODUCIBILITY_INSTANCE.md" in text
    assert "ECLIPSE_AUDIT_STABILITY_INSTANCE.md" in text
    assert "ECLIPSE_DEPENDENCY_CLOSURE_INSTANCE.md" in text
    assert "ECLIPSE_STATUS_TRUTHFULNESS_INSTANCE.md" in text
    assert "## Assembly schema" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)" in text
