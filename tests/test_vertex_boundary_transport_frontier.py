from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "chronos" / "Transport" / "VertexBoundaryTransport.lean"
DOC = ROOT / "docs" / "status" / "VERTEX_BOUNDARY_TRANSPORT_FRONTIER.md"


def test_vertex_boundary_transport_has_no_admit():
    text = LEAN.read_text()
    assert "admit" not in text


def test_vertex_boundary_transport_frontier_axiom_is_named():
    text = LEAN.read_text()
    assert "axiom entropy_mul_card_bound" in text
    assert "entropy_mul_card_bound C S.card" in text


def test_vertex_boundary_transport_status_boundary_exists():
    text = DOC.read_text()
    assert "Status: Conditional." in text
    assert "does not prove entropy transport unconditionally" in text
    assert "Build success verifies artifact integrity only" in text
