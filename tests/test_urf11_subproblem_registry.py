from pathlib import Path

ROOT = Path("docs/community/urf11")
BRIDGE_PATH = ROOT / "BRIDGE_REGISTRY.yaml"
SUBPROBLEM_PATH = ROOT / "SUBPROBLEM_REGISTRY.yaml"

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

def test_subproblem_registry_has_three_records_per_field():
    records = parse_list(SUBPROBLEM_PATH, "subproblem_records")
    assert len(records) == 33
    required = {"field_code", "subproblem_id", "title", "status"}
    assert {r["field_code"] for r in records} == {f"F{i}" for i in range(1, 12)}
    for entry in records:
        assert set(entry) == required
        assert all(entry[k].strip() for k in required)
        assert entry["status"] == "OPEN"

def test_every_bridge_source_subproblem_resolves_to_declared_field_subproblem():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    records = parse_list(SUBPROBLEM_PATH, "subproblem_records")
    declared = {(r["field_code"], r["subproblem_id"]) for r in records}
    assert len(bridges) == 11
    for bridge in bridges:
        pair = (bridge["source_field"], bridge["source_subproblem"])
        assert pair in declared
