from pathlib import Path

def test_envelope_propagation_preservation_obligation_lock() -> None:
    s = Path("docs/math/ENVELOPE_PROPAGATION_PRESERVATION_OBLIGATION.md").read_text()
    assert "Status: OPEN." in s
    assert r"\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}" in s
    assert r"\mathcal P(w)\Longrightarrow \mathcal P(\iota(w))" in s
    assert "repository-native admissibility propagates along the envelope bridge" in s
    assert "This note does not claim that the theorem above has been proved." in s
