from pathlib import Path

def test_local_cycle_rank_bound_lock():
    text = Path("docs/math/LOCAL_CYCLE_RANK_BOUND.md").read_text(encoding="utf-8")
    assert "\\mathbf{LCRB}" in text
    assert "\\text{Frontier status}=\\text{open}." in text
    assert "C_R(G)\\le B_{k,\\Delta,R}" in text
