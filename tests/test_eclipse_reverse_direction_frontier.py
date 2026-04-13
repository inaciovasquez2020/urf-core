from pathlib import Path

def test_eclipse_reverse_direction_frontier_lock():
    text = Path("docs/math/ECLIPSE_REVERSE_DIRECTION_FRONTIER.md").read_text(encoding="utf-8")
    assert "# Eclipse Reverse Direction Frontier" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Canonical adversary class" in text
    assert "## Minimal split" in text
    assert "### Lemma 1" in text
    assert "### Lemma 2" in text
    assert "### Lemma 3" in text
    assert "### Assembly" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{Eclipse}(\\mathcal P)" in text
