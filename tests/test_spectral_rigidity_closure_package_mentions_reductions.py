from pathlib import Path

def test_spectral_rigidity_closure_package_mentions_reductions() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_CLOSURE_PACKAGE.md").read_text()
    assert "ENVELOPE_WITNESS_INCLUSION_REDUCTION.md" in s
    assert "ENVELOPE_PROPAGATION_REDUCTION.md" in s
