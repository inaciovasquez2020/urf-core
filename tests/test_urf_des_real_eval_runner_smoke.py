import json
import subprocess
import sys
from pathlib import Path

import numpy as np

def test_real_eval_runner_smoke(tmp_path: Path):
    C = np.array([
        [2.0, 0.2, 0.0, 0.0],
        [0.2, 1.5, 0.1, 0.0],
        [0.0, 0.1, 1.2, 0.1],
        [0.0, 0.0, 0.1, 1.1],
    ])
    u_urf = np.array([1.0, 0.0, 0.0, 0.0])
    u_ia = np.array([0.2, 1.0, 0.0, 0.0])
    u_bar = np.array([0.1, 0.0, 1.0, 0.0])
    u_cal = np.array([0.3, 0.2, 0.1, 1.0])

    cov = tmp_path / "cov.csv"
    urf = tmp_path / "u_urf.csv"
    ia = tmp_path / "u_ia.csv"
    bar = tmp_path / "u_bar.csv"
    cal = tmp_path / "u_cal.csv"

    np.savetxt(cov, C, delimiter=",")
    np.savetxt(urf, u_urf, delimiter=",")
    np.savetxt(ia, u_ia, delimiter=",")
    np.savetxt(bar, u_bar, delimiter=",")
    np.savetxt(cal, u_cal, delimiter=",")

    result = subprocess.run(
        [
            sys.executable,
            "tools/run_urf_des_real_eval.py",
            "--cov", str(cov),
            "--u-urf", str(urf),
            "--u-ia", str(ia),
            "--u-bar", str(bar),
            "--u-cal", str(cal),
        ],
        check=True,
        capture_output=True,
        text=True,
    )

    out = json.loads(result.stdout)
    assert out["F_marg_URF"] > 0
    assert out["corr_URF_IA"] < 1
    assert out["corr_URF_bar"] < 1
    assert out["identifiability_pass"] is True
