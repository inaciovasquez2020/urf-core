from pathlib import Path

ROOT = Path("docs/community/urf11")
BRIDGE_PATH = ROOT / "BRIDGE_REGISTRY.yaml"
OBJECT_PATH = ROOT / "EXPORTED_OBJECT_REGISTRY.yaml"

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

def test_exported_object_registry_has_one_record_per_bridge():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    objects = parse_list(OBJECT_PATH, "exported_objects")
    bridge_ids = [b["exported_object"] for b in bridges]
    object_ids = [o["object_id"] for o in objects]
    assert len(bridges) == 11
    assert len(objects) == 11
    assert sorted(bridge_ids) == sorted(object_ids)
    assert len(set(object_ids)) == len(object_ids)

def test_every_bridge_exported_object_resolves_to_declared_record():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    objects = parse_list(OBJECT_PATH, "exported_objects")
    declared = {(o["source_field"], o["target_field"], o["object_id"]) for o in objects}
    required = {"object_id", "source_field", "target_field", "object_type", "interface_contract", "status"}
    for obj in objects:
        assert set(obj) == required
        assert obj["source_field"] != obj["target_field"]
        assert all(obj[k].strip() for k in required)
        assert obj["status"] == "OPEN"
    for bridge in bridges:
        key = (bridge["source_field"], bridge["target_field"], bridge["exported_object"])
        assert key in declared
