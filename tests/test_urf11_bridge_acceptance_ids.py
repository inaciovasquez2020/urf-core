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

def test_every_bridge_target_acceptance_is_canonical_id():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    acceptance = parse_list(ACCEPT_PATH, "acceptance_records")
    acceptance_id_by_field = {
        entry["field_code"]: entry["acceptance_id"]
        for entry in acceptance
    }
    assert len(bridges) == 11
    assert len(acceptance) == 11
    for bridge in bridges:
        assert bridge["target_field"] in acceptance_id_by_field
        assert bridge["target_acceptance_test"] == acceptance_id_by_field[bridge["target_field"]]
