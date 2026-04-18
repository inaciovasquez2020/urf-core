from pathlib import Path
import yaml

def test_repo_frontier_ledger_is_complete_relative_to_registry():
    reg = yaml.safe_load(Path("docs/status/CANONICAL_PERCENTAGE_REGISTRY.yaml").read_text())["registry"]
    led = yaml.safe_load(Path("docs/status/REPO_FRONTIER_LEDGER.yaml").read_text())["ledger"]
    reg_names = {r["repo"] for r in reg}
    led_names = {r["repo"] for r in led}
    assert reg_names == led_names
