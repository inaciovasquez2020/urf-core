from pathlib import Path

def test_cgi_lock():
    cgi = Path("docs/math/COERCIVE_GRADIENT_INEQUALITY.md").read_text(encoding="utf-8")
    bnd = Path("docs/math/SECTOR_BOUNDARY_SIZE.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{CGI}" in cgi
    assert "\\text{Frontier status}=\\text{open}." in cgi
    assert "\\partial_{\\mathrm{sec}}(G)" in cgi
    assert "\\partial_{\\mathrm{sec}}(G)" in bnd
    assert "\\text{Definition status}=\\text{locked}." in bnd
    assert "\\mathbf{CGI}" in rm
    assert "\\mathbf{CGI}\\Rightarrow \\mathbf{SDP}" in rm
