from pathlib import Path

ROOT = Path("docs/community/urf11")
PACKET_PATH = ROOT / "BRIDGE_PACKET_REGISTRY.yaml"
SUBPROBLEM_PATH = ROOT / "SUBPROBLEM_REGISTRY.yaml"
OBJECT_PATH = ROOT / "EXPORTED_OBJECT_REGISTRY.yaml"
RULE_PATH = ROOT / "TRANSLATION_RULE_REGISTRY.yaml"
ACCEPT_PATH = ROOT / "ACCEPTANCE_REGISTRY.yaml"
BENCH_PATH = ROOT / "BENCHMARK_REGISTRY.yaml"
WITNESS_PATH = ROOT / "PROMOTION_WITNESS_REGISTRY.yaml"
RESULT_PATH = ROOT / "BENCHMARK_RESULT_REGISTRY.yaml"
CERT_PATH = ROOT / "CURRENT_INSTANCE_REGISTRY_CLOSURE_CERTIFICATE.md"

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

def test_current_instance_registry_closure_certificate():
    text = CERT_PATH.read_text()
    assert "## Status\nPROVED" in text
    assert "Every current bridge packet closes through the subproblem, object, rule, acceptance, benchmark, witness, and result registries." in text

    packets = parse_list(PACKET_PATH, "bridge_packets")
    subproblems = parse_list(SUBPROBLEM_PATH, "subproblem_records")
    objects = parse_list(OBJECT_PATH, "exported_objects")
    rules = parse_list(RULE_PATH, "translation_rules")
    acceptance = parse_list(ACCEPT_PATH, "acceptance_records")
    benchmarks = parse_list(BENCH_PATH, "benchmarks")
    witnesses = parse_list(WITNESS_PATH, "promotion_witnesses")
    results = parse_list(RESULT_PATH, "benchmark_results")

    assert len(packets) == 11

    declared_subproblems = {(e["field_code"], e["subproblem_id"]) for e in subproblems}
    declared_objects = {(e["source_field"], e["target_field"], e["object_id"]) for e in objects}
    declared_rules = {(e["source_field"], e["target_field"], e["rule_id"]) for e in rules}
    acceptance_by_field = {e["field_code"]: e["acceptance_id"] for e in acceptance}
    benchmark_by_id = {e["id"]: e for e in benchmarks}
    witness_links = {(e["bridge_id"], e["benchmark"], e["acceptance_id"]) for e in witnesses}
    result_links = {(e["bridge_id"], e["benchmark"], e["status"]) for e in results}
    result_metric = {(e["bridge_id"], e["benchmark"]): e["metric"] for e in results}

    for packet in packets:
        assert (packet["source_field"], packet["source_subproblem"]) in declared_subproblems
        assert (packet["source_field"], packet["target_field"], packet["exported_object"]) in declared_objects
        assert (packet["source_field"], packet["target_field"], packet["translation_rule"]) in declared_rules
        assert packet["target_field"] in acceptance_by_field
        assert packet["acceptance_id"] == acceptance_by_field[packet["target_field"]]
        assert packet["benchmark"] in benchmark_by_id

        bench = benchmark_by_id[packet["benchmark"]]
        assert bench["source_field"] == packet["source_field"]
        assert bench["target_field"] == packet["target_field"]

        assert (packet["bridge_id"], packet["benchmark"], packet["acceptance_id"]) in witness_links
        assert (packet["bridge_id"], packet["benchmark"], "PASS") in result_links
        assert result_metric[(packet["bridge_id"], packet["benchmark"])] == bench["target_metric"]
