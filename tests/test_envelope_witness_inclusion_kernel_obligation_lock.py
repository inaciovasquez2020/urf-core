from pathlib import Path

def test_envelope_witness_inclusion_kernel_obligation_lock() -> None:
    s = Path("docs/math/ENVELOPE_WITNESS_INCLUSION_KERNEL_OBLIGATION.md").read_text()
    assert "Status: OPEN." in s
    assert r"\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}" in s
    assert r"\ker(\iota)=\{0\}" in s
    assert r"then \(\iota\) is injective" in s
    assert "This note does not claim that the theorem above has been proved." in s
