import subprocess


def test_urf_core_full_pytest_baseline_blockers():
    subprocess.run(
        ["python3", "-B", "tools/verify_urf_core_full_pytest_baseline_blockers.py"],
        check=True,
    )
