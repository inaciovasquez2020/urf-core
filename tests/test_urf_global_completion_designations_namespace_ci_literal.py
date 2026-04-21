from pathlib import Path

P = Path("docs/status/URF_GLOBAL_COMPLETION_DESIGNATIONS_V1_2026_04.md")

def test_namespace_and_ci_designation_literals():
    text = P.read_text()
    assert "### namespace_and_ci_integrity" in text
    assert "- `build/build`" in text
    assert "- `Lean Action CI/build`" in text
    assert "- `No Duplicate Namespace Check/check`" in text
    assert "- `verify/check`" in text
    assert "- `verify-surface/check`" in text
    assert "- `CI/test`" in text
