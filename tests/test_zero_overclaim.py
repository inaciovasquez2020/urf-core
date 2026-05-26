import subprocess

def test_zero_overclaim_verifier_passes():
    result = subprocess.run(
        ["python3", "tools/verify_zero_overclaim.py"],
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert "ZERO_OVERCLAIM_VERIFIER_OK" in result.stdout
