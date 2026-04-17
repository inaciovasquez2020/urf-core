import subprocess
import sys

def test_urf_frontier_registry_consistency():
    r = subprocess.run(
        [sys.executable, "scripts/check_urf_frontier_registry_consistency.py"],
        check=True,
        capture_output=True,
        text=True,
    )
    assert "urf-frontier-registry-consistency: PASS" in r.stdout
