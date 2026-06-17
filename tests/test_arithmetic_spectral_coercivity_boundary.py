import subprocess
import sys


def test_arithmetic_spectral_coercivity_boundary():
    subprocess.run(
        [sys.executable, "tools/verify_arithmetic_spectral_coercivity_boundary.py"],
        check=True,
    )
