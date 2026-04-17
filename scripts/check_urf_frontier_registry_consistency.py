#!/usr/bin/env python3
import json
from pathlib import Path

registry = Path("docs/status/URF_FRONTIER_REGISTRY_V1.json")
canonical = Path("docs/status/URF_REMAINING_FRONTIER_CANONICAL.md")

d = json.loads(registry.read_text())
s = canonical.read_text()

assert d["registry_version"] == 1
assert d["artifact"] == "URF_FRONTIER_REGISTRY_V1"
assert d["status"] == "CANONICAL"
assert d["frontier_id"] == "URF_RESIDUAL_FRONTIER"
assert d["canonical_source"] == "docs/status/URF_REMAINING_FRONTIER_CANONICAL.md"
assert d["escalation_policy"] == "forbid_stronger_downstream_status"
assert d["downstream_mode"] == "pointer_only"
assert d["open_boundary"]["name"] == "witness_family_boundary"
assert d["open_boundary"]["status"] == "OPEN"

assert "Status: CANONICAL" in s
assert "URF residual frontier" in s
assert "No public-facing whole-URF statement may claim stronger status than this file." in s

print("urf-frontier-registry-consistency: PASS")
