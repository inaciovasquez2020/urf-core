from pathlib import Path

def test_eclipse_star_final_snapshot():
    text = Path("docs/status/ECLIPSE_STAR_FINAL_SNAPSHOT.md").read_text()

    assert "Eclipse / Star Final Snapshot" in text
    assert "Conditional." in text
    assert "R2 \\prec R6 \\prec R5 \\prec R8." in text

    assert "R4" in text
    assert "R3" in text
    assert "R1" in text

    assert "\\text{Unconditional Eclipse equivalence}=\\text{not proved}." in text
