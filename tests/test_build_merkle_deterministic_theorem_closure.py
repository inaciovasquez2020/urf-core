from pathlib import Path

LEAN = Path("URFCore/BuildInvariant.lean")
STATUS = Path("docs/status/URF_CORE_BUILDMERKLEDETERMINISTIC_THEOREM_CLOSURE_2026_05_26.md")


def test_build_merkle_deterministic_is_theorem_not_axiom():
    text = LEAN.read_text()
    assert "theorem BuildMerkleDeterministic : True := by" in text
    assert "axiom BuildMerkleDeterministic" not in text


def test_build_merkle_deterministic_boundary_doc_exists():
    text = STATUS.read_text()
    assert "THEOREM_CLOSED_TRIVIAL_TRUE_SURFACE" in text
    assert "does not prove deterministic Merkle construction" in text
    assert "does not prove reproducibility of artifacts" in text
    assert "does not prove unrestricted Chronos-RR" in text
    assert "does not prove P vs NP" in text
    assert "does not prove any Clay problem" in text
