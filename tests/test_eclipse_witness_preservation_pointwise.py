from pathlib import Path

def test_eclipse_witness_preservation_pointwise_lock():
    text = Path("docs/math/ECLIPSE_WITNESS_PRESERVATION_POINTWISE.md").read_text(encoding="utf-8")
    assert "# Eclipse Witness Preservation Pointwise" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Role" in text
    assert "## Consequence" in text
    assert "## Terminal missing object" in text
    assert "\\forall a\\in A,\\forall k\\in K_0,\\quad" in text
    assert "\\operatorname{WitnessSet}(a(\\mathcal P_0))(k)=W_0(k)." in text
    assert "\\operatorname{CertifiesStatus}(\\operatorname{WitnessSet}(a(\\mathcal P_0))(k),S,k)" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),S,k)." in text
