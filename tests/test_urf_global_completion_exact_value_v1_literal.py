from pathlib import Path

EXACT = Path("docs/status/URF_GLOBAL_COMPLETION_EXACT_VALUE_V1_2026_04.md")
LOWER = Path("docs/status/URF_GLOBAL_COMPLETION_LOWER_BOUND_V1_2026_04.md")
DESIG = Path("docs/status/URF_GLOBAL_COMPLETION_DESIGNATIONS_V1_2026_04.md")

def test_exact_value_certificate_literals():
    text = EXACT.read_text()
    assert "## Status\nPROVED" in text
    assert "c(\\texttt{axioms_and_laws}) = \\frac{1}{4} = 0.25" in text
    assert "c(\\texttt{certificates_and_verifiers}) = \\frac{5}{5} = 1" in text
    assert "c(\\texttt{namespace_and_ci_integrity}) = \\frac{6}{6} = 1" in text
    assert "c(\\texttt{community_and_bridge_surfaces}) = \\frac{3}{3} = 1" in text
    assert "c(\\texttt{status_governance_and_audit}) = \\frac{8}{8} = 1" in text
    assert "c(\\texttt{global_completion_policy}) = 1" in text
    assert "P_{\\mathrm{URF}}" in text
    assert "=\n85." in text

def test_lower_bound_superseded_for_exact_reporting():
    text = LOWER.read_text()
    assert "Superseded operationally by `docs/status/URF_GLOBAL_COMPLETION_EXACT_VALUE_V1_2026_04.md` for exact reporting." in text

def test_certificates_and_verifiers_section_deduped():
    text = DESIG.read_text()
    start = text.index("### certificates_and_verifiers")
    end = text.index("### namespace_and_ci_integrity")
    section = text[start:end]
    assert section.count("tests/test_urf11_registry_closure_certificate.py") == 1
    assert section.count("tests/test_urf11_weak_interaction_computed.py") == 1
    assert section.count("tests/test_urf11_promotion_stability_computed.py") == 1
    assert section.count("tests/test_urf11_instance_certificates.py") == 1
    assert section.count("tests/test_urf_global_completion_lower_bound_literal.py") == 1
