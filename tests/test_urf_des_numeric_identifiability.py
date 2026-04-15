import numpy as np
from src.urf_des.compute_fisher import (
    fisher_matrix,
    marginalized_fisher_urf,
    corr_under_cov,
    identifiability_pass,
)

def test_numeric_identifiability_pipeline():
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
    U = np.column_stack([u_urf, u_ia, u_bar, u_cal])

    F = fisher_matrix(U, C)
    fm = marginalized_fisher_urf(F)
    rho_ia = corr_under_cov(u_urf, u_ia, C)
    rho_bar = corr_under_cov(u_urf, u_bar, C)

    assert F.shape == (4, 4)
    assert fm > 0
    assert rho_ia < 1
    assert rho_bar < 1
    assert identifiability_pass(U, C) is True
