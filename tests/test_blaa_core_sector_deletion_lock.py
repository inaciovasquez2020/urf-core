from pathlib import Path

def test_blaa_core_sector_deletion_lock():
    sdp = Path("docs/math/SECTOR_DELETION_PRESERVATION.md").read_text(encoding="utf-8")
    op = Path("docs/math/SECTOR_DELETION_OPERATOR.md").read_text(encoding="utf-8")
    mce = Path("docs/math/SECTOR_DELETION_MINIMAL_COUNTEREXAMPLE.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")
    assert "\\mathbf{SDP}" in sdp
    assert "\\text{Frontier status}=\\text{open}." in sdp
    assert "\\mathcal D_{\\mathrm{sec}}" in sdp
    assert "\\Phi(\\mathcal D_{\\mathrm{sec}}G)\\ge \\Phi(G)-\\delta_{k,\\Delta,R}" in sdp
    assert "\\mathcal D_{\\mathrm{sec}}" in op
    assert "\\text{Definition status}=\\text{locked}." in op
    assert "\\text{Theorem status}=\\text{open}." in op
    assert "\\mathbf{MCE}_{\\mathrm{SDP}}" in mce
    assert "\\Phi(\\mathcal D_{\\mathrm{sec}}G_\\star)<\\Phi(G_\\star)-\\delta_{k,\\Delta,R}" in mce
    assert "\\mathbf{SDP}=\\text{Sector-Deletion Preservation}" in rm
    assert "\\mathbf{SDP}\\Rightarrow \\mathbf{UEP}" in rm
