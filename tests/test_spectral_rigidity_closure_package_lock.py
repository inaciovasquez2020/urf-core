from pathlib import Path

def test_spectral_rigidity_closure_package_lock() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_CLOSURE_PACKAGE.md").read_text()
    assert "Status: OPEN" in s
    assert "ENVELOPE_WITNESS_INCLUSION.md" in s
    assert "ENVELOPE_RIGIDITY_PROPAGATION.md" in s
    assert "Unconditional spectral rigidity is admissible if and only if both theorem-level ingredients are discharged" in s
    assert "SpectralRigidity" in s
    assert "No unconditional spectral-rigidity theorem is claimed before both ingredients are proved." in s
