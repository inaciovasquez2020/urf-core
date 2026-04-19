from pathlib import Path

def test_spectral_rigidity_status_mentions_reductions() -> None:
    s = Path("docs/status/SPECTRAL_RIGIDITY_STATUS.md").read_text()
    assert "ENVELOPE_WITNESS_INCLUSION_REDUCTION.md" in s
    assert "ENVELOPE_PROPAGATION_REDUCTION.md" in s
