from pathlib import Path
import yaml

def test_critical_quartet_is_exact():
    reg = yaml.safe_load(Path("docs/status/CANONICAL_PERCENTAGE_REGISTRY.yaml").read_text())["registry"]
    critical = {r["repo"] for r in reg if r["critical"]}
    assert critical == {
        "urf-core",
        "chronos-urf-rr",
        "scientific-infrastructure",
        "urf-verifier",
    }
