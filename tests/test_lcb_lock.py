from pathlib import Path

def test_lcb_lock():
    lcb = Path("docs/math/LOCAL_CHANGE_BOUND.md").read_text(encoding="utf-8")
    var = Path("docs/math/EDGE_LOCAL_VARIATION.md").read_text(encoding="utf-8")
    red = Path("docs/math/LOCAL_TYPE_REDUCTION.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{LCB}" in lcb
    assert "\\text{Frontier status}=\\text{open}." in lcb
    assert "\\Delta_e \\Phi(G)" in lcb
    assert "\\Delta_e \\Phi(G)=\\Phi(G)-\\Phi(G\\setminus e)" in var
    assert "\\text{Definition status}=\\text{locked}." in var
    assert "\\Delta_e\\Phi(B_R(G,e))" in red
    assert "\\mathbf{LCB}" in rm
    assert "\\mathbf{LCB}\\Rightarrow \\mathbf{CGI}" in rm
