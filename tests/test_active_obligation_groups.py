import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "artifacts/urf/active_obligation_groups_2026_05_26.json"
VERIFY = ROOT / "tools/verify_active_obligation_groups.py"

def test_active_obligation_groups_verifier_runs():
    result = subprocess.run(["python3", str(VERIFY)], cwd=ROOT, text=True, capture_output=True)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "ACTIVE_OBLIGATION_GROUPS_OK" in result.stdout

def test_active_obligation_groups_boundary_and_exclusions():
    data = json.loads(ART.read_text())
    assert data["status"] == "ACTIVE_OBLIGATION_GROUPS_ONLY_NO_THEOREM_CLOSURE"
    for group in data["groups"].values():
        for item in group["items"]:
            parts = set(Path(item["path"]).parts)
            assert ".lake" not in parts
            assert "legacy" not in parts
    if data["total_active_obligations"] > 0:
        assert "descent_system_structural_descent" in data["groups"]
    assert "provenance_codec" not in data["groups"]
    assert "any Clay problem" in data["does_not_prove"]
