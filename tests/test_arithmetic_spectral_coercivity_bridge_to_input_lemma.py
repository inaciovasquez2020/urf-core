import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def test_arithmetic_spectral_coercivity_bridge_to_input_lemma_boundary():
    result = subprocess.run(
        [sys.executable, "tools/verify_arithmetic_spectral_coercivity_bridge_to_input_lemma.py"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "ARITHMETIC_SPECTRAL_COERCIVITY_BRIDGE_TO_INPUT_LEMMA_OK" in result.stdout
