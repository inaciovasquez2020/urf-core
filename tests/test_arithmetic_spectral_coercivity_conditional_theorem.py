import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def test_arithmetic_spectral_coercivity_conditional_theorem_boundary():
    result = subprocess.run(
        [sys.executable, "tools/verify_arithmetic_spectral_coercivity_target_coercive_from_interface.py"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "ARITHMETIC_SPECTRAL_COERCIVITY_CONDITIONAL_THEOREM_OK" in result.stdout
