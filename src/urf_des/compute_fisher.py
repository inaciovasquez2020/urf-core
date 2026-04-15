import numpy as np

def fisher_matrix(U: np.ndarray, C: np.ndarray) -> np.ndarray:
    U = np.asarray(U, dtype=float)
    C = np.asarray(C, dtype=float)
    C_inv = np.linalg.inv(C)
    return U.T @ C_inv @ U

def marginalized_fisher_urf(F: np.ndarray) -> float:
    F = np.asarray(F, dtype=float)
    a = F[0, 0]
    b = F[0, 1:]
    D = F[1:, 1:]
    return float(a - b @ np.linalg.inv(D) @ b.T)

def corr_under_cov(u: np.ndarray, v: np.ndarray, C: np.ndarray) -> float:
    u = np.asarray(u, dtype=float)
    v = np.asarray(v, dtype=float)
    C_inv = np.linalg.inv(np.asarray(C, dtype=float))
    num = float(u.T @ C_inv @ v)
    du = float(u.T @ C_inv @ u)
    dv = float(v.T @ C_inv @ v)
    if du <= 0 or dv <= 0:
        raise ValueError("non-positive covariance norm")
    return num / np.sqrt(du * dv)

def identifiability_pass(U: np.ndarray, C: np.ndarray) -> bool:
    F = fisher_matrix(U, C)
    fm = marginalized_fisher_urf(F)
    rho_ia = corr_under_cov(U[:, 0], U[:, 1], C)
    rho_bar = corr_under_cov(U[:, 0], U[:, 2], C)
    return bool(fm > 0 and rho_ia < 1 and rho_bar < 1)
