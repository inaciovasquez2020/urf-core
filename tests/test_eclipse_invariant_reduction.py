from pathlib import Path

def test_eclipse_invariant_reduction_lock():
    text = Path("docs/math/ECLIPSE_INVARIANT_REDUCTION.md").read_text(encoding="utf-8")
    assert "# Eclipse Invariant Reduction" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Reference witness" in text
    assert "## Reduction step" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{ReconstructionStable}_A(\\mathcal P)" in text
    assert "\\operatorname{StatusInvariant}_A(\\mathcal P)" in text
    assert "\\operatorname{DependencyInvariant}_A(\\mathcal P)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)" in text
