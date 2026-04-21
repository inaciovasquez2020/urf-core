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

def test_translation_rule_registry_has_one_record_per_bridge():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    rules = parse_list(RULE_PATH, "translation_rules")
    assert len(bridges) == 11
    assert len(rules) == 11
    ids = [r["rule_id"] for r in rules]
    assert len(set(ids)) == len(ids)

def test_every_bridge_translation_rule_resolves_to_declared_record():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    rules = parse_list(RULE_PATH, "translation_rules")
    required = {
        "rule_id",
        "source_field",
        "target_field",
        "bridge_translation_rule",
        "input_contract",
        "output_contract",
        "status",
    }
    declared = {(r["source_field"], r["target_field"], r["bridge_translation_rule"]) for r in rules}
    for rule in rules:
        assert set(rule) == required
        assert rule["source_field"] != rule["target_field"]
        assert all(rule[k].strip() for k in required)
        assert rule["status"] == "OPEN"
    for bridge in bridges:
        key = (bridge["source_field"], bridge["target_field"], bridge["translation_rule"])
        assert key in declared
