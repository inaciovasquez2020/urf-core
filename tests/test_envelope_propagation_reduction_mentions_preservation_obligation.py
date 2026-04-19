from pathlib import Path

def test_envelope_propagation_reduction_mentions_preservation_obligation() -> None:
    s = Path("docs/math/ENVELOPE_PROPAGATION_REDUCTION.md").read_text()
    assert "ENVELOPE_PROPAGATION_PRESERVATION_OBLIGATION.md" in s
