import json
from pathlib import Path

def test_concrete_phi_target_registered_not_proved():
    data = json.loads(
        Path("artifacts/urf/concrete_phi_using_extractrmatrix_target_2026_06_05.json").read_text()
    )
    assert data["status"] == "TARGET_REGISTERED_NOT_PROVED"
    assert data["closed_object"] == "ConcretePhiTargetRegistrationOnly"
    assert data["minimal_missing_object"] == "ConcretePhiDefinitionUsingExtractRMatrix"
    assert "ConcreteRankAgreement" in {
        item["name"] for item in data["required_obligations"]
    }
    assert "AbstractStepRealizesCanonicalF2Pivot" in {
        item["name"] for item in data["required_obligations"]
    }
    assert "DescentSystem.step_rank_drop" in data["not_closed"]
    assert "DescentSystem.zero_rank_reached_within_rank" in data["not_closed"]
    assert "P vs NP" in data["not_closed"]
