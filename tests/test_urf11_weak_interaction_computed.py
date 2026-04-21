from pathlib import Path

PACKET_PATH = Path("docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml")

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

def test_weak_interaction_computed_outdegree_lower_bound():
    packets = parse_list(PACKET_PATH, "bridge_packets")
    outdeg = {f"F{i}": 0 for i in range(1, 12)}
    for packet in packets:
        outdeg[packet["source_field"]] += 1
    assert len(packets) == 11
    assert sum(outdeg.values()) == 11
    for field_code in outdeg:
        assert outdeg[field_code] >= 1, (field_code, outdeg[field_code])
