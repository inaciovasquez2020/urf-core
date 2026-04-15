from pathlib import Path

def test_finite_patch_cycle_rigidity_note_present():
    p = Path("docs/math/FINITE_PATCH_CYCLE_RIGIDITY.md")
    assert p.exists()
    s = p.read_text(encoding="utf-8")
    assert "FO^k-homogeneity" in s
    assert "Z_1(G) / Z_1^{≤ 2R+1}(G)" in s or "Z_1(G) / Z_1^{<= 2R+1}(G)" in s
    assert "OPEN" in s
