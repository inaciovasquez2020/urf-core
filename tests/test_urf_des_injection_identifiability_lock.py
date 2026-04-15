from pathlib import Path

def test_urf_des_injection_identifiability_lock():
    math_text = Path("docs/math/URF_DES_INJECTION_IDENTIFIABILITY.md").read_text(encoding="utf-8")
    status_text = Path("docs/status/URF_DES_RESIDUAL_TARGETS.md").read_text(encoding="utf-8")

    assert "Status: Conditional." in math_text
    assert "R_5 \\succ R_2 \\succ R_3" in math_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})>0" in math_text
    assert "\\operatorname{corr}" in math_text
    assert "Conditional. Injection-recovery identifiability test pending." in math_text

    assert "Status: Conditional." in status_text
    assert "Conditional. Injection-recovery identifiability test pending." in status_text
    assert "R_5 \\succ R_2 \\succ R_3" in status_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})>0" in status_text
    assert "empirical verification" in status_text
    assert "unified explanation" in status_text
    assert "observational support" in status_text
