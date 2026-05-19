import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_universal_translation_theorem_equivalence_verifier():
    subprocess.run(
        ["python3", "scripts/verify_universal_translation_theorem_equivalence.py"],
        cwd=ROOT,
        check=True,
    )


def test_universal_translation_theorem_equivalence_boundary_doc():
    text = (
        ROOT / "docs/status/UNIVERSAL_TRANSLATION_THEOREM_EQUIVALENCE_2026_05_19.md"
    ).read_text()
    assert "Status: `CONDITIONAL_EQUIVALENCE_SURFACE`" in text
    assert "Conditional equivalence surface only." in text
    assert "Does not prove:" in text
    assert "UniversalTranslationTheorem" in text
    assert "P vs NP" in text
