#!/usr/bin/env python3
import json
from pathlib import Path

src = Path("docs/status/URF_FRONTIER_REGISTRY_V1.json")
out = Path("artifacts/URF_FRONTIER_POINTER_REGISTRY_V1.generated.json")
out.parent.mkdir(parents=True, exist_ok=True)

d = json.loads(src.read_text())
generated = {
    "registry_version": 1,
    "artifact": "URF_FRONTIER_POINTER_REGISTRY_V1",
    "status": "POINTER_ONLY",
    "upstream_registry": "https://github.com/inaciovasquez2020/urf-core/blob/main/docs/status/URF_FRONTIER_REGISTRY_V1.json",
    "upstream_canonical_source": "https://github.com/inaciovasquez2020/urf-core/blob/main/" + d["canonical_source"],
    "local_policy": "no_status_escalation",
    "local_role": "downstream_pointer",
}
out.write_text(json.dumps(generated, indent=2) + "\n")
print("emit-urf-frontier-pointer-registry: PASS")
