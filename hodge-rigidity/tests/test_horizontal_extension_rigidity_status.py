from pathlib import Path

def test_horizontal_extension_rigidity_status():
    s = Path("hodge-rigidity/docs/status/HORIZONTAL_EXTENSION_RIGIDITY_STATUS.md").read_text()
    assert "Status: OPEN" in s
    assert "HERT-3" in s
    assert "oscillation lower bound for flat non-horizontal Hodge tensors" in s
    assert "If HERT-3 is proved, then Horizontal Extension Rigidity is closed." in s
