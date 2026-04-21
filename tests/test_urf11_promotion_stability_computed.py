from pathlib import Path

ROOT = Path("docs/community/urf11")
REGISTRY_PATH = ROOT / "PROMOTION_PATH_REGISTRY.yaml"

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

def test_computed_promotion_stability_disjoint_from_locks():
    entries = parse_list(REGISTRY_PATH, "promotion_managed_paths")
    mutable_paths = {entry["path"] for entry in entries}
    assert len(entries) == 8
    for locked in LOCKED_PATHS:
        assert Path(locked).exists(), locked
    assert mutable_paths.isdisjoint(LOCKED_PATHS)
