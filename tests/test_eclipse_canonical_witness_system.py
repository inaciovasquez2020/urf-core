from pathlib import Path

def test_eclipse_canonical_witness_system_lock():
    text = Path("docs/math/ECLIPSE_CANONICAL_WITNESS_SYSTEM.md").read_text(encoding="utf-8")
    assert "# Eclipse Canonical Witness System" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Witness specification" in text
    assert "## Canonical conditions" in text
    assert "## Certification obligations" in text
    assert "### Obligation 1" in text
    assert "### Obligation 2" in text
    assert "### Obligation 3" in text
    assert "### Obligation 4" in text
    assert "## Assembly target" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)" in text
