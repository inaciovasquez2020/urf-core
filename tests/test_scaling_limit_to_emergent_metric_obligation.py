import subprocess


def test_scaling_limit_to_emergent_metric_obligation_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_scaling_limit_to_emergent_metric_obligation.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "SCALING_LIMIT_TO_EMERGENT_METRIC_OBLIGATION_OK" in result.stdout
