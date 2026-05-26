from pathlib import Path

LEAN = Path("URF/Boundary/TreeToy.lean")
STATUS = Path("docs/status/URF_TREE_TOY_ISTREE_THEOREM_CLOSURE_2026_05_26.md")


def test_tree_toy_istree_is_theorem_not_axiom():
    text = LEAN.read_text()
    assert "theorem isTree : True := by" in text
    assert "axiom isTree : True" not in text


def test_tree_toy_istree_boundary_doc_exists():
    text = STATUS.read_text()
    assert "THEOREM_CLOSED_TRIVIAL_TRUE_SURFACE" in text
    assert "does not prove a nontrivial tree theorem" in text
    assert "does not prove graph-theoretic tree structure" in text
    assert "does not prove unrestricted Chronos-RR" in text
    assert "does not prove P vs NP" in text
    assert "does not prove any Clay problem" in text
