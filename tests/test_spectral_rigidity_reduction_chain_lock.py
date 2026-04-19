from pathlib import Path

def test_spectral_rigidity_reduction_chain_lock() -> None:
    a = Path("docs/math/ENVELOPE_WITNESS_INCLUSION_REDUCTION.md").read_text()
    b = Path("docs/math/ENVELOPE_PROPAGATION_REDUCTION.md").read_text()
    c = Path("docs/math/SPECTRAL_RIGIDITY_CLOSURE_PACKAGE.md").read_text()
    d = Path("docs/status/SPECTRAL_RIGIDITY_STATUS.md").read_text()

    assert "Status: OPEN." in a
    assert "Status: OPEN." in b
    assert "Status: CONDITIONAL" in d

    assert r"\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}" in a
    assert r"\iota : W_{\mathrm{env}} \to W_{\mathrm{repo}}" in b
    assert r"\mathcal P(\iota(w))" in b

    assert "## Closed reductions" in c
    assert "No unconditional spectral-rigidity theorem is claimed before both ingredients are proved." in c
    assert "ENVELOPE_WITNESS_INCLUSION_FRONTIER.md" in d
    assert "ENVELOPE_PROPAGATION_FRONTIER.md" in d

    assert "No unconditional spectral-rigidity theorem is currently proved." in d
    assert "Unconditional closure is admissible only after both frontier ingredients are discharged." in d
