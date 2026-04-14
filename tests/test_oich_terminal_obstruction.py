from pathlib import Path

def test_oich_terminal_obstruction_lock():
    text = Path("docs/math/OICH_TERMINAL_OBSTRUCTION.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert "Ordered Invariant Compression Hypothesis (OICH)" in text
    assert "\\mathrm{VCdim}(\\mathcal F)\\le d" in text
    assert "\\delta_{\\mathcal F}:[M]^{\\le d}\\to \\mathcal P([M])" in text
    assert "\\delta_{\\pi\\mathcal F}(\\pi(S))=\\pi\\!\\big(\\delta_{\\mathcal F}(S)\\big)" in text
    assert "\\mathrm{VCCL}\\wedge \\mathrm{OICH}\\Longrightarrow \\mathrm{BCL}" in text
    assert "The unique remaining theorem-level compression object is OICH." in text

def test_lcb_compression_frontier_lock():
    text = Path("docs/status/LCB_COMPRESSION_FRONTIER.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert "\\text{Structural reduction phase}=\\text{complete}." in text
    assert "\\text{Theorem-certification phase}=\\text{open}." in text
    assert "\\text{Unique remaining object}=\\text{Ordered Invariant Compression Hypothesis (OICH)}." in text
    assert "\\text{Repository stopping point}=\\text{good}." in text
