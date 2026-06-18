import subprocess


def test_emergent_metric_einstein_limit_obligation_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_emergent_metric_einstein_limit_obligation.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "EMERGENT_METRIC_EINSTEIN_LIMIT_OBLIGATION_OK" in result.stdout
