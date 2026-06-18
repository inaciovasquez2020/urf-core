import subprocess


def test_metric_candidate_compatibility_with_scaling_limit_obligation_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_metric_candidate_compatibility_with_scaling_limit_obligation.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "METRIC_CANDIDATE_COMPATIBILITY_WITH_SCALING_LIMIT_OBLIGATION_OK" in result.stdout
