from pathlib import Path

def test_mcr_lock():
    text = Path("docs/math/MEASURE_CYCLE_RIGIDITY_TARGET.md").read_text()
    assert "MCR(k,\\Delta,R)" in text
    assert "rank" in text

def test_fss_lock():
    text = Path("docs/math/FINITE_TYPE_SPECTRAL_SEPARATION_TARGET.md").read_text()
    assert "FSS(k,\\Delta,R)" in text
    assert "lambda" in text

def test_ebe_lock():
    text = Path("docs/math/ECLIPSE_BRIDGE_EQUIVALENCE_TARGET.md").read_text()
    assert "EBE" in text
    assert "Witness" in text and "TheoremCert" in text
