from pathlib import Path

def test_eclipse_instance_certified_derivation_lock():
    text = Path("docs/math/ECLIPSE_INSTANCE_CERTIFIED_DERIVATION.md").read_text(encoding="utf-8")
    assert "# Eclipse Instance Certified Derivation" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Imported inputs" in text
    assert "ECLIPSE_EXTERNAL_REPRODUCIBILITY_INSTANCE.md" in text
    assert "ECLIPSE_AUDIT_STABILITY_INSTANCE.md" in text
    assert "ECLIPSE_DEPENDENCY_CLOSURE_INSTANCE.md" in text
    assert "ECLIPSE_STATUS_TRUTHFULNESS_INSTANCE.md" in text
    assert "ECLIPSE_INSTANCE_CERTIFICATION_ASSEMBLY.md" in text
    assert "## Certified derivation schema" in text
    assert "### Step 1" in text
    assert "### Step 2" in text
    assert "### Step 3" in text
    assert "### Step 4" in text
    assert "## Terminal missing lemma" in text
    assert "\\operatorname{StatusInvariant}_A(\\mathcal P_0)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)" in text
