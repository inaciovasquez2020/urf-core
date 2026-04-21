from pathlib import Path

ROOT = Path("docs/community/urf11")
BRIDGE_PATH = ROOT / "BRIDGE_REGISTRY.yaml"
ACCEPT_PATH = ROOT / "ACCEPTANCE_REGISTRY.yaml"

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

def test_acceptance_registry_has_one_record_per_field():
    acceptance = parse_list(ACCEPT_PATH, "acceptance_records")
    assert len(acceptance) == 11
    required = {"field_code", "acceptance_id", "acceptance_statement", "witness_type", "status"}
    assert {e["field_code"] for e in acceptance} == {f"F{i}" for i in range(1, 12)}
    for entry in acceptance:
        assert set(entry) == required
        assert all(entry[k].strip() for k in required)
        assert entry["status"] == "OPEN"

def test_every_bridge_target_acceptance_resolves_to_declared_field():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    acceptance = parse_list(ACCEPT_PATH, "acceptance_records")
    fields = {e["field_code"] for e in acceptance}
    assert len(bridges) == 11
    for bridge in bridges:
        assert bridge["target_field"] in fields
        assert bridge["target_acceptance_test"].strip()
