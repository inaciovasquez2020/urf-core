from pathlib import Path
import yaml

def test_canonical_percentage_registry_exists_and_is_well_formed():
    p = Path("docs/status/CANONICAL_PERCENTAGE_REGISTRY.yaml")
    assert p.exists()
    data = yaml.safe_load(p.read_text())
    assert data["source_of_truth"] == "urf-core"
    rows = data["registry"]
    assert any(r["repo"] == "urf-core" for r in rows)
    for r in rows:
        assert 0 <= r["percent_min"] <= r["percent_max"] <= 100
        assert r["class"] in {"core", "bridge", "application", "experimental"}
        assert isinstance(r["critical"], bool)
