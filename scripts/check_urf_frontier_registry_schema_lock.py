#!/usr/bin/env python3
import json
from pathlib import Path

p = Path("docs/status/URF_FRONTIER_REGISTRY_V1.json")
d = json.loads(p.read_text())

assert set(d.keys()) == {
    "registry_version",
    "artifact",
    "status",
    "date",
    "frontier_id",
    "canonical_source",
    "scope",
    "escalation_policy",
    "downstream_mode",
    "open_boundary",
}
assert set(d["open_boundary"].keys()) == {"name", "status"}
print("urf-frontier-registry-schema-lock: PASS")
