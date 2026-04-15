from pathlib import Path

def test_urf_des_bridge_closure_step_2():
    math_text = Path("docs/math/URF_DES_MARGINALIZED_FISHER_OBJECT.md").read_text(encoding="utf-8")
    status_text = Path("docs/status/URF_DES_BRIDGE_CLOSURE_STEP_2.md").read_text(encoding="utf-8")

    assert "Status: Conditional." in math_text
    assert "F_{ij}" in math_text
    assert "u_i^{\\!\\top} C_{\\mathrm{DES}}^{-1} u_j" in math_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})" in math_text
    assert "F_{N,N}^{-1}" in math_text
    assert "Conditional. Marginalized Fisher object defined; numerical evaluation pending." in math_text

    assert "Status: Conditional." in status_text
    assert "F_{ij}" in status_text
    assert "F_{\\mathrm{marg}}(\\theta_{\\mathrm{URF}},\\theta_{\\mathrm{URF}})" in status_text
    assert "empirical verification" in status_text
    assert "observational support" in status_text
    assert "unified explanation" in status_text
