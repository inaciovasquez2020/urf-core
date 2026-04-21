from pathlib import Path

ROOT = Path("docs/community/urf11")
POLICY_PATH = ROOT / "PROMOTION_SCOPE_POLICY.md"

PROMOTION_MANAGED_PATHS = [
    "docs/community/urf11/BRIDGE_REGISTRY.yaml",
    "docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml",
    "docs/community/urf11/BENCHMARK_REGISTRY.yaml",
    "docs/community/urf11/BENCHMARK_RESULT_REGISTRY.yaml",
    "docs/community/urf11/ACCEPTANCE_REGISTRY.yaml",
    "docs/community/urf11/EXPORTED_OBJECT_REGISTRY.yaml",
    "docs/community/urf11/TRANSLATION_RULE_REGISTRY.yaml",
    "docs/community/urf11/PROMOTION_WITNESS_REGISTRY.yaml",
    "docs/community/urf11/PROMOTION_SCOPE_POLICY.md",
    "docs/community/urf11/PROMOTION_SEMANTICS.md",
]

def test_promotion_nonescape():
    text = POLICY_PATH.read_text()
    assert "## Status\nOPEN" in text
    assert "docs/community/urf11" in text
    for rel in PROMOTION_MANAGED_PATHS:
        assert rel.startswith("docs/community/urf11"), rel
        assert Path(rel).exists(), rel
