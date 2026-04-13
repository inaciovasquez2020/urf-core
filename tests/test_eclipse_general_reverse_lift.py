from pathlib import Path

def test_eclipse_general_reverse_lift_lock():
    text = Path("docs/math/ECLIPSE_GENERAL_REVERSE_LIFT.md").read_text(encoding="utf-8")
    assert "# Eclipse General Reverse Lift" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Inputs" in text
    assert "## Reduction" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ExternalReproducible}(\\mathcal P)" in text
    assert "\\operatorname{AuditStable}(\\mathcal P)" in text
    assert "\\operatorname{DependencyClosed}(\\mathcal P)" in text
    assert "\\operatorname{StatusTruthful}(\\mathcal P)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P)." in text
    assert "\\operatorname{CanonicalWitnessInstance}(\\mathcal Q)" in text
    assert "\\mathcal Q\\sim_{\\mathrm{ext}}\\mathcal P" in text
    assert "\\operatorname{Eclipse}(\\mathcal Q)\\iff \\operatorname{Eclipse}(\\mathcal P)" in text
    assert "\\operatorname{CoreClaims}(\\mathcal Q)=\\operatorname{CoreClaims}(\\mathcal P)" in text
    assert "\\operatorname{StatusMap}(\\mathcal Q)=\\operatorname{StatusMap}(\\mathcal P)" in text
    assert "\\operatorname{DependencyGraph}(\\mathcal Q)\\cong \\operatorname{DependencyGraph}(\\mathcal P)" in text
