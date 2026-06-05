import subprocess
import sys


def test_f2_descent_state_definition_verifier():
    subprocess.run(
        [sys.executable, "tools/verify_f2_descent_state_definition.py"],
        check=True,
    )
