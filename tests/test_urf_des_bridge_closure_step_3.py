from pathlib import Path

def test_urf_des_bridge_closure_step_3():
    math_text = Path("docs/math/URF_DES_IDENTIFIABILITY_DECISION_RULE.md").read_text(encoding="utf-8")
    status_text = Path("docs/status/URF_DES_BRIDGE_CLOSURE_STEP_3.md").read_text(encoding="utf-8")

    assert "Status: Conditional." in math_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})>0" in math_text
    assert "\\rho_{\\mathrm{IA}}" in math_text
    assert "\\rho_{\\mathrm{bar}}" in math_text
    assert "\\textbf{PASS}" in math_text
    assert "\\textbf{FAIL}" in math_text
    assert "Conditional. Decision rule defined; numerical pass/fail evaluation pending." in math_text

    assert "Status: Conditional." in status_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})>0" in status_text
    assert "\\operatorname{corr}(u_{\\mathrm{URF}},u_{\\mathrm{IA}})<1" in status_text
    assert "\\operatorname{corr}(u_{\\mathrm{URF}},u_{\\mathrm{bar}})<1" in status_text
    assert "empirical verification" in status_text
    assert "observational support" in status_text
    assert "unified explanation" in status_text
