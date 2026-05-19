import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_universal_translation_preservation_verifier():
    subprocess.run(
        ["python3", "scripts/verify_universal_translation_preservation.py"],
        cwd=ROOT,
        check=True,
    )


def test_universal_translation_preservation_preserves_boundary():
    text = (ROOT / "docs/status/UNIVERSAL_TRANSLATION_PRESERVATION_2026_05_19.md").read_text()
    assert "Does not prove:" in text
    assert "unconditional UniversalTranslationTheorem" in text
    assert "unrestricted UniversalFiberEntropyGap" in text
    assert "P vs NP" in text
    assert "any Clay problem" in text
