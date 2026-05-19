import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_universal_rigidity_grammar_open_lock_verifier():
    subprocess.run(
        ["python3", "scripts/verify_universal_rigidity_grammar_open_lock.py"],
        cwd=ROOT,
        check=True,
    )


def test_universal_rigidity_grammar_open_lock_preserves_boundary():
    text = (ROOT / "docs/status/UNIVERSAL_RIGIDITY_GRAMMAR_OPEN_LOCK_2026_05_19.md").read_text()
    assert "Does not prove:" in text
    assert "unrestricted UniversalFiberEntropyGap" in text
    assert "P vs NP" in text
    assert "any Clay problem" in text
