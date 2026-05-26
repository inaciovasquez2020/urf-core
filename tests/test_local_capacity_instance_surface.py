import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_local_capacity_instance_surface.py"

def test_local_capacity_instance_surface_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "LOCAL_CAPACITY_INSTANCE_SURFACE_OK" in result.stdout
