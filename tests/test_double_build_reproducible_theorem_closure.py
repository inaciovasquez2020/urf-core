from pathlib import Path

LEAN = Path("URFCore/Reproducibility.lean")
STATUS = Path("docs/status/URF_CORE_DOUBLEBUILD_REPRODUCIBLE_THEOREM_CLOSURE_2026_05_26.md")


def test_double_build_reproducible_is_theorem_not_axiom():
    text = LEAN.read_text()
    assert "theorem DoubleBuildImpliesReproducible : True := by" in text
    assert "axiom DoubleBuildImpliesReproducible" not in text


def test_double_build_reproducible_boundary_doc_exists():
    text = STATUS.read_text()
    assert "THEOREM_CLOSED_TRIVIAL_TRUE_SURFACE" in text
    assert "does not prove real artifact reproducibility" in text
    assert "does not prove deterministic build-system behavior" in text
    assert "does not prove Merkle-root correctness" in text
    assert "does not prove unrestricted Chronos-RR" in text
    assert "does not prove P vs NP" in text
    assert "does not prove any Clay problem" in text
