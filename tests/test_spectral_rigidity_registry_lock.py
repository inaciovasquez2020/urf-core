from pathlib import Path

def test_spectral_rigidity_registry_lock() -> None:
    s = Path("docs/status/SPECTRAL_RIGIDITY_STATUS.md").read_text()
    assert "Status: CONDITIONAL" in s
    assert "ENVELOPE_WITNESS_INCLUSION_FRONTIER.md" in s
    assert "ENVELOPE_PROPAGATION_FRONTIER.md" in s
    assert "No unconditional spectral-rigidity theorem is currently proved." in s
    assert "Unconditional closure is admissible only after both frontier ingredients are discharged." in s
