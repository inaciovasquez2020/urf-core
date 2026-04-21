import json
from pathlib import Path

MODEL = Path("docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json")
RULES = Path("docs/status/URF_GLOBAL_COMPLETION_SCORING_RULES_2026_04.md")
ASSUMPTION = Path("docs/status/URF_GLOBAL_COMPLETION_WEIGHT_MODEL_ASSUMPTION_2026_04.md")


def test_global_completion_model_weights_sum_to_one():
    data = json.loads(MODEL.read_text())
    weights = [m["weight"] for m in data["modules"]]
    assert data["model_id"] == "urf-global-completion-v1-2026-04"
    assert abs(sum(weights) - 1.0) < 1e-12
    assert len(data["modules"]) == 6
    assert all(0.0 <= w <= 1.0 for w in weights)


def test_global_completion_policy_literals_present():
    rules = RULES.read_text()
    assumption = ASSUMPTION.read_text()
    assert "## Status\nCANONICAL" in rules
    assert "`policy_declared_and_tested`" in rules
    assert "## Status\nPROVED-AS-POLICY" in assumption
    assert "URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json" in assumption
    assert "URF_GLOBAL_COMPLETION_SCORING_RULES_2026_04.md" in assumption
