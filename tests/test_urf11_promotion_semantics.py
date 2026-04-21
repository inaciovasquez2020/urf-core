from pathlib import Path

ROOT = Path("docs/community/urf11")
PACKET_PATH = ROOT / "BRIDGE_PACKET_REGISTRY.yaml"
WITNESS_PATH = ROOT / "PROMOTION_WITNESS_REGISTRY.yaml"
RESULT_PATH = ROOT / "BENCHMARK_RESULT_REGISTRY.yaml"
SEMANTICS_PATH = ROOT / "PROMOTION_SEMANTICS.md"

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

def Promote(packet, witnesses, results):
    witness_match = any(
        w["bridge_id"] == packet["bridge_id"]
        and w["benchmark"] == packet["benchmark"]
        and w["acceptance_id"] == packet["acceptance_id"]
        for w in witnesses
    )
    result_match = any(
        r["bridge_id"] == packet["bridge_id"]
        and r["benchmark"] == packet["benchmark"]
        and r["status"] == "PASS"
        for r in results
    )
    return 1 if witness_match and result_match else 0

def test_promotion_semantics_literal():
    text = SEMANTICS_PATH.read_text()
    assert "## Status\nOPEN" in text
    assert "Promote(Pi_{i->j}) = 1 iff there exists a declared witness record matching the bridge packet and there exists a declared benchmark result record with status PASS for the same bridge_id and benchmark." in text
    assert "benchmark_status" in text
    assert "PASS" in text

def test_promote_implies_benchmark_status_pass():
    packets = parse_list(PACKET_PATH, "bridge_packets")
    witnesses = parse_list(WITNESS_PATH, "promotion_witnesses")
    results = parse_list(RESULT_PATH, "benchmark_results")
    promoted = 0
    for packet in packets:
        p = Promote(packet, witnesses, results)
        if p == 1:
            promoted += 1
            assert any(
                r["bridge_id"] == packet["bridge_id"]
                and r["benchmark"] == packet["benchmark"]
                and r["status"] == "PASS"
                for r in results
            )
    assert promoted == len(packets) == 11
