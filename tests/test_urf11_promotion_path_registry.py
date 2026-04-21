from pathlib import Path

ROOT = Path("docs/community/urf11")
REGISTRY_PATH = ROOT / "PROMOTION_PATH_REGISTRY.yaml"

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

def test_promotion_path_registry_nonescape():
    entries = parse_list(REGISTRY_PATH, "promotion_managed_paths")
    assert len(entries) == 8
    required = {"path", "scope", "status"}
    for entry in entries:
        assert set(entry) == required
        assert entry["scope"] == "mutable"
        assert entry["status"] == "OPEN"
        assert entry["path"].startswith("docs/community/urf11"), entry["path"]
        assert Path(entry["path"]).exists(), entry["path"]
