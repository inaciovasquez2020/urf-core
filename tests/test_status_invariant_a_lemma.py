from pathlib import Path

def test_status_invariant_a_lemma_lock() -> None:
    path = Path("docs/math/STATUS_INVARIANT_A_LEMMA.md")
    text = path.read_text(encoding="utf-8")
    assert "operatorname{StatusInvariant}_A(\\mathcal P_0)" in text
    assert "operatorname{AuditCoverage}_A(\\mathcal P_0)" in text
    assert "operatorname{AuditStable}(\\mathcal P_0)" in text
    assert "operatorname{StatusTruthful}(\\mathcal P_0)" in text
    assert "docs/math/ECLIPSE_INSTANCE_CERTIFIED_DERIVATION.md" in text
    assert "\\text{Frontier status}=\\text{Conditional}" in text
