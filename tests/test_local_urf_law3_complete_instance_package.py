import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_local_urf_law3_complete_instance_package.py"

def test_local_urf_law3_complete_instance_package_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "LOCAL_URF_LAW3_COMPLETE_INSTANCE_PACKAGE_OK" in result.stdout
