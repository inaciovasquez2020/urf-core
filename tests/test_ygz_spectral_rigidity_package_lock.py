from pathlib import Path

def test_ygz_spectral_rigidity_package_lock() -> None:
    s = Path("docs/math/YGZ_SPECTRAL_RIGIDITY_PACKAGE.md").read_text()
    assert "Status: CONDITIONAL." in s
    assert r"\mathrm{YGZ}:=" in s
    assert r"W_{\mathrm{env}}" in s
    assert r"W_{\mathrm{repo}}" in s
    assert r"\iota:W_{\mathrm{env}}\to W_{\mathrm{repo}}" in s
    assert r"\mathcal P" in s
    assert r"\mathfrak I:W_{\mathrm{env}}\to\mathcal S" in s
    assert r"\mathfrak I(w)=0\iff w=0" in s
    assert r"\mathcal P(w)\Longrightarrow \mathcal P(\iota(w))" in s
    assert r"\ker(\iota)=\{0\}" in s
    assert "conditional resolution schema" in s

def test_final_wall_mentions_ygz_package() -> None:
    s = Path("docs/math/SPECTRAL_RIGIDITY_FINAL_WALL.md").read_text()
    assert "YGZ_SPECTRAL_RIGIDITY_PACKAGE.md" in s

def test_status_mentions_ygz_package() -> None:
    s = Path("docs/status/SPECTRAL_RIGIDITY_STATUS.md").read_text()
    assert "YGZ_SPECTRAL_RIGIDITY_PACKAGE.md" in s
