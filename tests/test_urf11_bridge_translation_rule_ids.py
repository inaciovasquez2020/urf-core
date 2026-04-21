from pathlib import Path

ROOT = Path("docs/community/urf11")
BRIDGE_PATH = ROOT / "BRIDGE_REGISTRY.yaml"
RULE_PATH = ROOT / "TRANSLATION_RULE_REGISTRY.yaml"

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

def test_every_bridge_translation_rule_is_canonical_id():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    rules = parse_list(RULE_PATH, "translation_rules")
    rule_id_by_pair = {
        (entry["source_field"], entry["target_field"]): entry["rule_id"]
        for entry in rules
    }
    assert len(bridges) == 11
    assert len(rules) == 11
    for bridge in bridges:
        pair = (bridge["source_field"], bridge["target_field"])
        assert pair in rule_id_by_pair
        assert bridge["translation_rule"] == rule_id_by_pair[pair]
