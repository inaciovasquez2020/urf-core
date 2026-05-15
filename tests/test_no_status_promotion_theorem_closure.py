import subprocess
import sys

def test_no_status_promotion_theorem_closure():
    subprocess.run(
        [sys.executable, "tools/verify_no_status_promotion_theorem_closure.py"],
        check=True,
    )
