from pathlib import Path

def test_envelope_rigidity_propagation_lock() -> None:
    s = Path("docs/math/ENVELOPE_RIGIDITY_PROPAGATION.md").read_text()
    assert "Status: OPEN" in s
    assert "EnvelopeRigidity" in s
    assert "EnvelopeWitnessInclusion" in s
    assert "SpectralRigidity u C0 A θ" in s
    assert "it does not prove it" in s
