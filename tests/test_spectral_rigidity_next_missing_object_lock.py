from pathlib import Path

def test_spectral_rigidity_next_missing_object_lock() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_NEXT_MISSING_OBJECT.md").read_text()
    assert "Status: OPEN" in s
    assert "scratch/urf/SpectralRigidityBridge.lean" in s
    assert "docs/math/SPECTRAL_RIGIDITY_BRIDGE.md" in s
    assert "envelope witness inclusion" in s
    assert "envelope rigidity propagated by the actual flow" in s
    assert "No unconditional spectral-rigidity theorem is claimed until those two ingredients are discharged." in s
