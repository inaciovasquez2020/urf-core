import subprocess


def test_geometric_observable_convergence_obligation_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_geometric_observable_convergence_obligation.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "GEOMETRIC_OBSERVABLE_CONVERGENCE_OBLIGATION_OK" in result.stdout
