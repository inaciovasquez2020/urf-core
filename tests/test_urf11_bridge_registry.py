from pathlib import Path

BRIDGE_PATH = Path("docs/community/urf11/BRIDGE_REGISTRY.yaml")
REQUIRED_KEYS = {
    "source_field",
    "source_subproblem",
    "target_field",
    "exported_object",
    "translation_rule",
    "target_acceptance_test",
    "benchmark",
    "status",
}
FIELD_CODES = {f"F{i}" for i in range(1, 12)}
ALLOWED_STATUS = {"OPEN", "TESTING", "PROMOTED"}

def load_bridges():
    entries = []
    current = None
    in_bridges = False
    for raw in BRIDGE_PATH.read_text().splitlines():
        if raw == "bridges:":
            in_bridges = True
            continue
        if raw == "rules:":
            if current is not None:
                entries.append(current)
            break
        if not in_bridges:
            continue
        if raw.startswith("  - "):
            if current is not None:
                entries.append(current)
            key, value = raw[4:].split(":", 1)
            current = {key.strip(): value.strip()}
            continue
        if current is not None and raw.startswith("    "):
            key, value = raw.strip().split(":", 1)
            current[key.strip()] = value.strip()
    return entries

def V_bridge(entry):
    if set(entry) != REQUIRED_KEYS:
        return False
    if entry["source_field"] not in FIELD_CODES or entry["target_field"] not in FIELD_CODES:
        return False
    if entry["source_field"] == entry["target_field"]:
        return False
    if entry["status"] not in ALLOWED_STATUS:
        return False
    return all(entry[k].strip() for k in REQUIRED_KEYS)

def test_bridge_registry_has_one_outgoing_packet_per_field():
    bridges = load_bridges()
    seen = {entry["source_field"] for entry in bridges}
    assert seen == FIELD_CODES

def test_every_bridge_packet_passes_V_bridge():
    bridges = load_bridges()
    assert len(bridges) == 11
    for entry in bridges:
        assert V_bridge(entry), entry
