#!/usr/bin/env python3
import json
from pathlib import Path

artifact_path = Path("artifacts/urf/arithmetic_spectral_coercivity_existing_work_negative_fixture_2026_06_17.json")

required = {
    "artifact": "arithmetic_spectral_coercivity_existing_work_negative_fixture_2026_06_17",
    "status": "negative_fixture",
    "classification": "CONDITIONAL_INTERFACE_ONLY_NO_EXISTING_NONCIRCULAR_ARITHMETIC_SPECTRAL_BRIDGE",
    "missing_object": "foundation_to_arithmetic_spectral_coercivity_bridge",
}

data = json.loads(artifact_path.read_text())

for key, value in required.items():
    assert data.get(key) == value, f"{key} mismatch: {data.get(key)!r}"

assert "witness field" in data.get("first_structural_error", "")
assert "conditional" in data.get("accepted_boundary", "")

print("ARITHMETIC_SPECTRAL_COERCIVITY_EXISTING_WORK_NEGATIVE_FIXTURE_OK")
