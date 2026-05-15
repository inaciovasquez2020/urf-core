import subprocess
import sys

def test_urf_admissible_normalization_boundaries():
    subprocess.run(
        [sys.executable, "tools/verify_urf_admissible_normalization_boundaries.py"],
        check=True,
    )
