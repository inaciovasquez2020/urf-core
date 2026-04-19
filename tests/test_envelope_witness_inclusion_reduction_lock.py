from pathlib import Path

def test_envelope_witness_inclusion_reduction_lock() -> None:
    s = Path("docs/math/ENVELOPE_WITNESS_INCLUSION_REDUCTION.md").read_text()
    assert "Status: OPEN." in s
    assert r"\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}" in s
    assert "well-defined and injective" in s
    assert "repository-native witness class" in s
    assert r"\ker(\iota)=\{0\}" in s
    assert "This note does not claim that the theorem above has been proved." in s
