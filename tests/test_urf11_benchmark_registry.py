from pathlib import Path

ROOT = Path("docs/community/urf11")
BRIDGE_PATH = ROOT / "BRIDGE_REGISTRY.yaml"
BENCH_PATH = ROOT / "BENCHMARK_REGISTRY.yaml"

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

def test_every_bridge_benchmark_is_declared_once():
    bridges = parse_list(BRIDGE_PATH, "bridges")
    benchmarks = parse_list(BENCH_PATH, "benchmarks")
    bridge_ids = [b["benchmark"] for b in bridges]
    registry_ids = [b["id"] for b in benchmarks]
    assert len(bridge_ids) == 11
    assert len(registry_ids) == 11
    assert sorted(bridge_ids) == sorted(registry_ids)
    assert len(set(registry_ids)) == len(registry_ids)

def test_benchmark_registry_has_required_fields():
    benchmarks = parse_list(BENCH_PATH, "benchmarks")
    required = {
        "id",
        "source_field",
        "target_field",
        "source_metric",
        "target_metric",
        "interface_contract",
        "witness_type",
        "status",
    }
    for entry in benchmarks:
        assert set(entry) == required
        assert entry["source_field"] != entry["target_field"]
        assert all(entry[k].strip() for k in required)
