from pathlib import Path

def test_eclipse_witness_status_uniqueness_certified_lock():
    text = Path("docs/math/ECLIPSE_WITNESS_STATUS_UNIQUENESS_CERTIFIED.md").read_text(encoding="utf-8")
    assert "# Eclipse Witness Status Uniqueness Certified" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Inputs" in text
    assert "## Reduction" in text
    assert "## Conclusion" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),S,k)" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),S',k)" in text
    assert "\\Rightarrow S=S'." in text
    assert "(\\mathrm{PROVED},\\mathrm{CONDITIONAL})" in text
    assert "(\\mathrm{PROVED},\\mathrm{OPEN})" in text
    assert "(\\mathrm{CONDITIONAL},\\mathrm{OPEN})" in text
    assert "pairwise exclusions imply uniqueness" in text
