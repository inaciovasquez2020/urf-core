import subprocess
import sys

def test_descent_first_remaining_admit_boundary():
    subprocess.run(
        [sys.executable, "tools/verify_descent_first_remaining_admit_boundary.py"],
        check=True,
    )
