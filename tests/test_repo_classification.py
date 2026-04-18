from pathlib import Path
import yaml

def test_repo_classification_partitions_registry():
    reg = yaml.safe_load(Path("docs/status/CANONICAL_PERCENTAGE_REGISTRY.yaml").read_text())["registry"]
    cls = yaml.safe_load(Path("docs/status/REPO_CLASSIFICATION.yaml").read_text())["classes"]
    reg_names = {r["repo"] for r in reg}
    cls_names = set().union(*[set(v) for v in cls.values()])
    assert reg_names == cls_names
    for k in ["core", "bridge", "application", "experimental"]:
        assert k in cls
