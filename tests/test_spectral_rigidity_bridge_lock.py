from pathlib import Path

def test_spectral_rigidity_bridge_lock() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_BRIDGE.md").read_text()
    assert "Status: CONDITIONAL" in s
    assert "The Lean file `scratch/urf/SpectralRigidityBridge.lean` builds." in s
    assert "spectralRigidity_of_envelopeRigidity" in s
    assert "rigidity_persistence_via_envelope" in s
    assert "No unconditional spectral-rigidity conclusion is claimed from this file alone." in s
