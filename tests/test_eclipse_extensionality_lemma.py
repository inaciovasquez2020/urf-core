from pathlib import Path

def test_eclipse_extensionality_lemma_lock():
    text = Path("docs/math/ECLIPSE_EXTENSIONALITY_LEMMA.md").read_text(encoding="utf-8")
    assert "# Eclipse Extensionality Lemma" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Target" in text
    assert "## Role" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{CoreClaims}(\\mathcal P)=\\operatorname{CoreClaims}(\\mathcal Q)" in text
    assert "\\operatorname{StatusMap}(\\mathcal P)=\\operatorname{StatusMap}(\\mathcal Q)" in text
    assert "\\operatorname{DependencyGraph}(\\mathcal P)\\cong \\operatorname{DependencyGraph}(\\mathcal Q)" in text
    assert "\\operatorname{Eclipse}(\\mathcal P)\\iff \\operatorname{Eclipse}(\\mathcal Q)" in text
