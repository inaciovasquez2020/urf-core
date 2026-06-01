import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_global_valid_kernel_theorem_target.py"

def test_global_valid_kernel_theorem_target_verifier_passes():
    result = subprocess.run(
        [sys.executable, str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "GLOBAL_VALID_KERNEL_THEOREM_TARGET_OK" in result.stdout
