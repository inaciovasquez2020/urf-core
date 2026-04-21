from pathlib import Path

ROOT = Path("docs/community/urf11")
PACKET_PATH = ROOT / "BRIDGE_PACKET_REGISTRY.yaml"
PATH_REGISTRY = ROOT / "PROMOTION_PATH_REGISTRY.yaml"
WITNESS_PATH = ROOT / "PROMOTION_WITNESS_REGISTRY.yaml"
RESULT_PATH = ROOT / "BENCHMARK_RESULT_REGISTRY.yaml"
WEAK_CERT = ROOT / "CURRENT_INSTANCE_WEAK_INTERACTION_CERTIFICATE.md"
STAB_CERT = ROOT / "CURRENT_INSTANCE_PROMOTION_STABILITY_CERTIFICATE.md"

LOCKED_PATHS = {
    "docs/community/urf11/WEAK_INTERACTION_THEOREM.md",
    "docs/community/urf11/PROMOTION_STABILITY_LAW.md",
    "docs/community/urf11/PROMOTION_SCOPE_POLICY.md",
    "docs/community/urf11/PROMOTION_SEMANTICS.md",
}

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

def test_current_instance_weak_interaction_certificate():
    text = WEAK_CERT.read_text()
    assert "## Status\nOPEN" in text
    assert "deg^{+}(F_i)\ge 1" in text
    assert "Every field currently has at least one outgoing bridge packet." in text

    packets = parse_list(PACKET_PATH, "bridge_packets")
    outdeg = {f"F{i}": 0 for i in range(1, 12)}
    for packet in packets:
        outdeg[packet["source_field"]] += 1
    assert len(packets) == 11
    for field_code in outdeg:
        assert outdeg[field_code] >= 1, (field_code, outdeg[field_code])

def test_current_instance_promotion_stability_certificate():
    text = STAB_CERT.read_text()
    assert "## Status\nOPEN" in text
    assert "benchmark\\_status}=\\texttt{PASS}" in text
    assert "Promotion is currently confined to docs/community/urf11" in text

    path_entries = parse_list(PATH_REGISTRY, "promotion_managed_paths")
    mutable_paths = {entry["path"] for entry in path_entries}
    assert len(path_entries) == 8
    for path in mutable_paths:
        assert path.startswith("docs/community/urf11"), path
        assert Path(path).exists(), path
    assert mutable_paths.isdisjoint(LOCKED_PATHS)

    packets = parse_list(PACKET_PATH, "bridge_packets")
    witnesses = parse_list(WITNESS_PATH, "promotion_witnesses")
    results = parse_list(RESULT_PATH, "benchmark_results")
    assert len(packets) == 11
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
    assert promoted == 11
