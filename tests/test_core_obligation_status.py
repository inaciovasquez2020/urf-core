import subprocess
import sys

def test_core_obligation_status_guard_passes():
    subprocess.run(
        [sys.executable, "scripts/check_core_obligation_status.py"],
        check=True,
    )
