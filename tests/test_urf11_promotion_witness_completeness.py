from pathlib import Path

ROOT = Path("docs/community/urf11")
PACKET_PATH = ROOT / "BRIDGE_PACKET_REGISTRY.yaml"
WITNESS_PATH = ROOT / "PROMOTION_WITNESS_REGISTRY.yaml"

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

def test_one_witness_per_bridge_packet():
    packets = parse_list(PACKET_PATH, "bridge_packets")
    witnesses = parse_list(WITNESS_PATH, "promotion_witnesses")
    packet_ids = [entry["bridge_id"] for entry in packets]
    witness_ids = [entry["bridge_id"] for entry in witnesses]
    assert len(packets) == 11
    assert len(witnesses) == 11
    assert sorted(packet_ids) == sorted(witness_ids)
    for bridge_id in packet_ids:
        assert witness_ids.count(bridge_id) == 1, bridge_id
