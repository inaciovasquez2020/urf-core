from pathlib import Path

ROOT = Path("docs/community/urf11")
POLICY_PATH = ROOT / "PROMOTION_SCOPE_POLICY.md"
PACKET_PATH = ROOT / "BRIDGE_PACKET_REGISTRY.yaml"
WITNESS_PATH = ROOT / "PROMOTION_WITNESS_REGISTRY.yaml"

PROMOTION_MUTABLE_PATHS = [
    "docs/community/urf11/BRIDGE_REGISTRY.yaml",
    "docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml",
    "docs/community/urf11/BENCHMARK_REGISTRY.yaml",
    "docs/community/urf11/ACCEPTANCE_REGISTRY.yaml",
    "docs/community/urf11/EXPORTED_OBJECT_REGISTRY.yaml",
    "docs/community/urf11/TRANSLATION_RULE_REGISTRY.yaml",
    "docs/community/urf11/PROMOTION_WITNESS_REGISTRY.yaml",
]

def parse_list(path: Path, key_name: str):
    entries = []
    current = None
    in_section = False
    for raw in path.read_text().splitlines():
        if raw == f"{key_name}:":
            in_section = True
            continue
        if not in_section:
            continue
        if raw and not raw.startswith(" "):
            break
        if raw.startswith("  - "):
            if current is not None:
                entries.append(current)
            key, value = raw[4:].split(":", 1)
            current = {key.strip(): value.strip()}
            continue
        if current is not None and raw.startswith("    ") and ":" in raw:
            key, value = raw.strip().split(":", 1)
            current[key.strip()] = value.strip()
    if current is not None:
        entries.append(current)
    return entries

def test_promotion_scope_policy_literals_and_paths():
    text = POLICY_PATH.read_text()
    assert "## Status\nOPEN" in text
    assert "Delta_promote subseteq docs/community/urf11." in text
    assert "No promotion may rewrite canonical theorem, dependency, or closure claims outside docs/community/urf11." in text
    for rel in PROMOTION_MUTABLE_PATHS:
        assert rel.startswith("docs/community/urf11")
        assert Path(rel).exists(), rel

def test_promotion_witness_registry_resolves_to_bridge_packets():
    packets = parse_list(PACKET_PATH, "bridge_packets")
    witnesses = parse_list(WITNESS_PATH, "promotion_witnesses")
    declared_bridge_ids = {entry["bridge_id"] for entry in packets}
    declared_links = {(entry["bridge_id"], entry["benchmark"], entry["acceptance_id"]) for entry in packets}
    assert len(packets) == 11
    assert len(witnesses) == 11
    for witness in witnesses:
        assert set(witness) == {"bridge_id", "benchmark", "acceptance_id", "witness_type", "status"}
        assert witness["bridge_id"] in declared_bridge_ids
        assert (witness["bridge_id"], witness["benchmark"], witness["acceptance_id"]) in declared_links
        assert witness["witness_type"].strip()
        assert witness["status"] == "OPEN"
