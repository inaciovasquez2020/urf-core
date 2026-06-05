
import json
from pathlib import Path

def test_f2_descent_bridge_correction_artifact():
    data = json.loads(Path("artifacts/urf/f2_descent_bridge_correction_2026_06_05.json").read_text())
    assert data["status"] == "CONDITIONAL_BRIDGE_TARGET_ONLY"
    assert "AbstractStepRealizesCanonicalF2Pivot" == data["minimal_missing_theorem"]
    assert "F2DescentTerminates" in data["not_closed"]
    assert "DescentSystem.step_rank_drop" in data["not_closed"]
    assert "DescentSystem.zero_rank_reached_within_rank" in data["not_closed"]
    assert "P vs NP" in data["does_not_prove"]
