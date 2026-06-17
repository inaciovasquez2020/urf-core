import subprocess
import sys
from pathlib import Path


def test_arithmetic_spectral_coercivity_existing_work_negative_fixture_verifier():
    repo = Path(__file__).resolve().parents[1]
    result = subprocess.run(
        [
            sys.executable,
            "tools/verify_arithmetic_spectral_coercivity_existing_work_negative_fixture.py",
        ],
        cwd=repo,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "ARITHMETIC_SPECTRAL_COERCIVITY_EXISTING_WORK_NEGATIVE_FIXTURE_OK" in result.stdout
