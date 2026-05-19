import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def test_universal_translation_missing_objects_verifier():
    subprocess.run(
        ["python3", "scripts/verify_universal_translation_missing_objects.py"],
        cwd=ROOT,
        check=True,
    )

def test_universal_translation_missing_objects_boundary_doc():
    text = (
        ROOT / "docs/status/UNIVERSAL_TRANSLATION_MISSING_OBJECTS_2026_05_19.md"
    ).read_text()
    assert "Status: CONDITIONAL_MISSING_OBJECTS_SURFACE" in text
    assert "Conditional missing-objects surface only." in text
    assert "Does not prove:" in text
    assert "UniversalTranslationMissingObjects" in text
    assert "P vs NP" in text

def test_universal_translation_missing_objects_artifact():
    data = json.loads(
        (ROOT / "artifacts/urf/universal_translation_missing_objects_2026_05_19.json").read_text()
    )
    assert data["status"] == "CONDITIONAL_MISSING_OBJECTS_SURFACE"
    assert "UniversalTranslationMissingObjects" in data["created_objects"]
