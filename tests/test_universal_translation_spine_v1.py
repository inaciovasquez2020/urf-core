import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def test_universal_translation_spine_v1_verifier():
    subprocess.run(
        ["python3", "scripts/verify_universal_translation_spine_v1.py"],
        cwd=ROOT,
        check=True,
    )
