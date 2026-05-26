import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_finite_cmi_to_local_cmi_nonneg_interface.py"

def test_finite_cmi_to_local_cmi_nonneg_interface_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "FINITE_CMI_TO_LOCAL_CMI_NONNEG_INTERFACE_OK" in result.stdout
