from pathlib import Path
import json
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
BENCH = ROOT / "docs" / "benchmarks" / "cycle_local_rigidity"

def test_benchmark_estimators_and_promotion_blocker():
    ss = Path("docs/math/SS_BENCHMARK_ESTIMATOR.md").read_text(encoding="utf-8")
    lc = Path("docs/math/LCRB_BENCHMARK_SURROGATE.md").read_text(encoding="utf-8")
    pb = Path("docs/math/EMPIRICAL_PROMOTION_BLOCKER.md").read_text(encoding="utf-8")
    rm = Path("docs/math/REMAINING_MATHEMATICAL_CLOSURE_FINAL.md").read_text(encoding="utf-8")

    assert "\\widehat{\\lambda}_{\\mathrm{sep}}^{\\mathcal B}(G)" in ss
    assert "\\text{Estimator status}=\\text{locked}." in ss
    assert "\\text{Theorem status}=\\text{open}." in ss

    assert "\\widehat{C}_2^{\\mathcal B}(G)" in lc
    assert "\\text{Surrogate status}=\\text{locked}." in lc
    assert "\\text{Theorem status}=\\text{open}." in lc

    assert "\\text{Empirical verification}" in pb
    assert "\\mathbf{SSW},\\ \\mathbf{LCRB}_{\\mathcal B}\\ \\text{remain OPEN.}" in pb

    assert "\\widehat{\\lambda}_{\\mathrm{sep}}^{\\mathcal B}" in rm
    assert "\\widehat{C}_2^{\\mathcal B}" in rm

    proc = subprocess.run(
        [sys.executable, "evaluate_ss_lcrb_benchmark.py"],
        cwd=BENCH,
        capture_output=True,
        text=True,
    )
    assert proc.returncode == 0, proc.stderr + proc.stdout

    report = BENCH / "artifacts" / "ss_lcrb_empirical_report.json"
    assert report.exists()
    data = json.loads(report.read_text(encoding="utf-8"))
    assert "ssw_empirical_counterexample_found" in data
    assert "lcrb_benchmark_upper_bound_observed" in data
    assert data["promotion_admissible"] is False
