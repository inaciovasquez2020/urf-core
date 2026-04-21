import json
from pathlib import Path

MODEL = Path("docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json")
LOWER = Path("docs/status/URF_GLOBAL_COMPLETION_LOWER_BOUND_V1_2026_04.md")
POLICY = Path("docs/status/URF_GLOBAL_COMPLETION_WEIGHT_MODEL_ASSUMPTION_2026_04.md")
REG = Path("docs/community/urf11/CURRENT_INSTANCE_REGISTRY_CLOSURE_CERTIFICATE.md")
WEAK = Path("docs/community/urf11/CURRENT_INSTANCE_WEAK_INTERACTION_CERTIFICATE.md")
STAB = Path("docs/community/urf11/CURRENT_INSTANCE_PROMOTION_STABILITY_CERTIFICATE.md")


def test_global_completion_lower_bound_literals():
    text = LOWER.read_text()
    assert "## Status\nPROVED" in text
    assert "P_{\\mathrm{URF}} \\ge 30." in text
    assert "100\\bigl(0.15\\cdot 1 + 0.15\\cdot 1\\bigr)" in text
    assert "This is a certified lower bound only." in text


def test_global_completion_lower_bound_witnesses():
    model = json.loads(MODEL.read_text())
    weights = {m["id"]: m["weight"] for m in model["modules"]}
    assert abs(weights["community_and_bridge_surfaces"] - 0.15) < 1e-12
    assert abs(weights["global_completion_policy"] - 0.15) < 1e-12
    assert "## Status\nPROVED" in REG.read_text()
    assert "## Status\nPROVED" in WEAK.read_text()
    assert "## Status\nPROVED" in STAB.read_text()
    assert "## Status\nPROVED-AS-POLICY" in POLICY.read_text()
