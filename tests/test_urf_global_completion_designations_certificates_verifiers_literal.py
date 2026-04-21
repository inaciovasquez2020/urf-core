from pathlib import Path

P = Path("docs/status/URF_GLOBAL_COMPLETION_DESIGNATIONS_V1_2026_04.md")

def test_certificates_and_verifiers_designation_literals():
    text = P.read_text()
    assert "### certificates_and_verifiers" in text
    assert "- `docs/community/urf11/CURRENT_INSTANCE_REGISTRY_CLOSURE_CERTIFICATE.md`" in text
    assert "- `docs/community/urf11/CURRENT_INSTANCE_WEAK_INTERACTION_CERTIFICATE.md`" in text
    assert "- `docs/community/urf11/CURRENT_INSTANCE_PROMOTION_STABILITY_CERTIFICATE.md`" in text
    assert "- `docs/status/URF_GLOBAL_COMPLETION_LOWER_BOUND_V1_2026_04.md`" in text
    assert "- `tests/test_urf11_registry_closure_certificate.py`" in text
    assert "- `tests/test_urf11_weak_interaction_computed.py`" in text
    assert "- `tests/test_urf11_promotion_stability_computed.py`" in text
    assert "- `tests/test_urf11_instance_certificates.py`" in text
    assert "- `tests/test_urf_global_completion_lower_bound_literal.py`" in text
