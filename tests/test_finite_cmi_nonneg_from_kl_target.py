import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_finite_cmi_nonneg_from_kl_target.py"

def test_finite_cmi_nonneg_from_kl_target_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "FINITE_CMI_NONNEG_FROM_KL_TARGET_OK" in result.stdout
