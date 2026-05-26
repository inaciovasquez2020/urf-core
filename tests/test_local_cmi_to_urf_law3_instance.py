import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_local_cmi_to_urf_law3_instance.py"

def test_local_cmi_to_urf_law3_instance_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "LOCAL_CMI_TO_URF_LAW3_INSTANCE_OK" in result.stdout
