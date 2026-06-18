import subprocess


def test_metric_like_candidate_construction_obligation_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_metric_like_candidate_construction_obligation.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "METRIC_LIKE_CANDIDATE_CONSTRUCTION_OBLIGATION_OK" in result.stdout
