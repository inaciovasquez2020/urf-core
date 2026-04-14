from pathlib import Path
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BENCH = ROOT / "docs" / "benchmarks" / "cycle_local_rigidity"

def test_ss_counterexample_search_lock():
    text = Path("docs/math/FINITE_TYPE_SPECTRAL_SEPARATION_COUNTEREXAMPLE_SEARCH.md").read_text(encoding="utf-8")
    assert "\\text{Search target}=\\mathbf{SS}" in text
    assert "\\text{Frontier status}=\\text{open}." in text
    proc = subprocess.run(
        [sys.executable, "search_ss_counterexample.py"],
        cwd=BENCH,
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 0, proc.stderr + proc.stdout
    out = BENCH / "artifacts" / "ss_counterexample_search.json"
    assert out.exists()
    rows = json.loads(out.read_text(encoding="utf-8"))
    assert isinstance(rows, list)
