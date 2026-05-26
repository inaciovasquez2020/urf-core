import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "tools/verify_urf_law3_primitive_obligation_localization.py"

def test_urf_law3_primitive_obligation_localization_verifier():
    result = subprocess.run(
        ["python3", str(VERIFY)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "URF_LAW3_PRIMITIVE_OBLIGATION_LOCALIZATION_OK" in result.stdout
