import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

import numpy as np

from src.urf_des.compute_fisher import (
    fisher_matrix,
    marginalized_fisher_urf,
    corr_under_cov,
    identifiability_pass,
)

def load_array(path: str) -> np.ndarray:
    p = Path(path)
    if p.suffix == ".npy":
        return np.load(p)
    if p.suffix == ".csv":
        return np.loadtxt(p, delimiter=",")
    raise ValueError(f"unsupported file type: {p.suffix}")

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cov", required=True, help="Path to DES-like covariance matrix (.csv or .npy)")
    parser.add_argument("--u-urf", required=True, help="Path to URF template vector (.csv or .npy)")
    parser.add_argument("--u-ia", required=True, help="Path to IA template vector (.csv or .npy)")
    parser.add_argument("--u-bar", required=True, help="Path to baryonic template vector (.csv or .npy)")
    parser.add_argument("--u-cal", required=True, help="Path to calibration template vector (.csv or .npy)")
    args = parser.parse_args()

    C = load_array(args.cov)
    u_urf = load_array(args.u_urf).reshape(-1)
    u_ia = load_array(args.u_ia).reshape(-1)
    u_bar = load_array(args.u_bar).reshape(-1)
    u_cal = load_array(args.u_cal).reshape(-1)

    U = np.column_stack([u_urf, u_ia, u_bar, u_cal])
    F = fisher_matrix(U, C)
    fm = marginalized_fisher_urf(F)
    rho_ia = corr_under_cov(u_urf, u_ia, C)
    rho_bar = corr_under_cov(u_urf, u_bar, C)
    passed = identifiability_pass(U, C)

    out = {
        "F_marg_URF": float(fm),
        "corr_URF_IA": float(rho_ia),
        "corr_URF_bar": float(rho_bar),
        "identifiability_pass": bool(passed),
    }
    print(json.dumps(out, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()
