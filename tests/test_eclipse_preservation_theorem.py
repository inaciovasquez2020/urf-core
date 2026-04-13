from pathlib import Path

def test_eclipse_preservation_theorem_lock():
    text = Path("docs/math/ECLIPSE_PRESERVATION_THEOREM.md").read_text(encoding="utf-8")
    assert "# Eclipse Preservation Theorem" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "\\operatorname{Eclipse}(\\mathcal P)" in text
    assert "\\operatorname{ExternalReproducible}(\\mathcal P)" in text
    assert "\\operatorname{AuditStable}(\\mathcal P)" in text
    assert "\\operatorname{DependencyClosed}(\\mathcal P)" in text
    assert "\\operatorname{StatusTruthful}(\\mathcal P)" in text
    assert "## Frontier split" in text
    assert "## Terminal missing object" in text
