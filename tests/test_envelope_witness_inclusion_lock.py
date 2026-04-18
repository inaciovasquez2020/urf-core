from pathlib import Path

def test_envelope_witness_inclusion_lock() -> None:
    s = Path("docs/math/ENVELOPE_WITNESS_INCLUSION.md").read_text()
    assert "Status: OPEN" in s
    assert "EnvelopeWitnessInclusion u C0" in s
    assert "SpectralRigidity u C0 A θ" in s
    assert "it does not prove it" in s
