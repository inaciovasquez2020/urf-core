import subprocess
import sys

def test_urf_law3_entropy_nonamplification():
    subprocess.run(
        [sys.executable, "tools/verify_urf_law3_entropy_nonamplification.py"],
        check=True,
    )
