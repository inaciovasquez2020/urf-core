from pathlib import Path

def test_ss_lcrb_sublemmas_lock():
    ssw = Path("docs/math/SS_BENCHMARK_WITNESS_EXCLUSION.md").read_text(encoding="utf-8")
    lcrbb = Path("docs/math/LCRB_BENCHMARK_BOUND.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{SSW}" in ssw
    assert "\\text{Frontier status}=\\text{open}." in ssw
    assert "\\lambda_{\\mathrm{sep}}(G)\\ge \\varepsilon_{\\mathcal B}" in ssw
    assert "\\mathbf{LCRB}_{\\mathcal B}" in lcrbb
    assert "\\text{Frontier status}=\\text{open}." in lcrbb
    assert "C_2(G)\\le B_{\\mathcal B}" in lcrbb
    assert "\\mathbf{SSW}=\\text{benchmark witness-sequence exclusion under }\\mathbf{SS}" in rm
    assert "\\mathbf{LCRB}_{\\mathcal B}=\\text{benchmark-family local cycle-rank bound under }\\mathbf{LCRB}" in rm
