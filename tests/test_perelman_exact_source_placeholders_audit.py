from pathlib import Path

def test_perelman_exact_source_placeholders_audit():
    text = Path("docs/status/PERELMAN_EXACT_SOURCE_PLACEHOLDER_AUDIT.md").read_text(encoding="utf-8")
    assert "# Perelman Exact-Source Placeholder Audit" in text
    assert "PL-0001" in text
    assert "PL-0006" in text
    assert "`verbatim_source_excerpt`" in text
    assert "`normalized_statement`" in text
