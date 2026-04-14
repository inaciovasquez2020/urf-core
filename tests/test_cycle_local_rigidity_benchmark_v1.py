from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BENCH = ROOT / "docs" / "benchmarks" / "cycle_local_rigidity"

def test_cycle_local_rigidity_benchmark_v1():
    proc = subprocess.run(
        [sys.executable, "-m", "pytest", "-q", "tests/test_verify.py"],
        cwd=BENCH,
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 0, proc.stderr + proc.stdout
