import json
from pathlib import Path

def test_urf_frontier_registry_v1():
    p = Path("docs/status/URF_FRONTIER_REGISTRY_V1.json")
    d = json.loads(p.read_text())
    assert d["registry_version"] == 1
    assert d["artifact"] == "URF_FRONTIER_REGISTRY_V1"
    assert d["status"] == "CANONICAL"
    assert d["frontier_id"] == "URF_RESIDUAL_FRONTIER"
    assert d["canonical_source"] == "docs/status/URF_REMAINING_FRONTIER_CANONICAL.md"
    assert d["escalation_policy"] == "forbid_stronger_downstream_status"
    assert d["downstream_mode"] == "pointer_only"
    assert d["open_boundary"]["name"] == "witness_family_boundary"
    assert d["open_boundary"]["status"] == "OPEN"
