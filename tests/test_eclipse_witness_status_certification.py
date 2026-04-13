from pathlib import Path

def test_eclipse_witness_status_certification_lock():
    text = Path("docs/math/ECLIPSE_WITNESS_STATUS_CERTIFICATION.md").read_text(encoding="utf-8")
    assert "# Eclipse Witness Status Certification" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Definition" in text
    assert "## Pairwise exclusivity" in text
    assert "## Uniqueness consequence" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),\\mathrm{PROVED},k)" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),\\mathrm{CONDITIONAL},k)" in text
    assert "\\operatorname{CertifiesStatus}(W_0(k),\\mathrm{OPEN},k)" in text
    assert "W_0(k)\\text{ certifies }k." in text
    assert "W_0(k)\\text{ certifies the exact missing lemma/hypothesis for }k." in text
    assert "W_0(k)\\text{ certifies absence of a proof of }k." in text
    assert "\\Big(\\n\\operatorname{CertifiesStatus}(W_0(k),S,k)\\wedge" in text or "\\operatorname{CertifiesStatus}(W_0(k),S,k)\\wedge" in text
    assert "\\Big)\\Rightarrow S=S'." in text or "\\Rightarrow S=S'." in text
