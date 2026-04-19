from pathlib import Path

def test_spectral_rigidity_status_mentions_final_wall() -> None:
    s = Path("docs/status/SPECTRAL_RIGIDITY_STATUS.md").read_text()
    assert "SPECTRAL_RIGIDITY_FINAL_WALL.md" in s
