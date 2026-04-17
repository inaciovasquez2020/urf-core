import json
import subprocess
import sys
from pathlib import Path

def test_emit_urf_frontier_pointer_registry():
    r = subprocess.run(
        [sys.executable, "tools/emit_urf_frontier_pointer_registry.py"],
        check=True,
        capture_output=True,
        text=True,
    )
    assert "emit-urf-frontier-pointer-registry: PASS" in r.stdout
    d = json.loads(Path("artifacts/URF_FRONTIER_POINTER_REGISTRY_V1.generated.json").read_text())
    assert d["status"] == "POINTER_ONLY"
    assert d["local_policy"] == "no_status_escalation"
