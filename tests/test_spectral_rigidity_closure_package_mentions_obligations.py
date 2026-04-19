from pathlib import Path

def test_spectral_rigidity_closure_package_mentions_obligations() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_CLOSURE_PACKAGE.md").read_text()
    assert "ENVELOPE_WITNESS_INCLUSION_KERNEL_OBLIGATION.md" in s
    assert "ENVELOPE_PROPAGATION_PRESERVATION_OBLIGATION.md" in s
