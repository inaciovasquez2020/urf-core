#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ART = ROOT / "artifacts/urf/active_obligation_groups_2026_05_26.json"

SCAN_ROOTS = [
    "lean",
    "chronos",
    "URFCore",
    "URF",
    "admissible",
    "spine",
    "urf_law3.lean",
    "finite_cmi_nonneg_from_kl.lean",
    "finite_cmi_to_local_cmi_nonneg_interface.lean",
]

EXCLUDED_PARTS = {".git", ".lake", "legacy", "node_modules", ".venv", "venv", "__pycache__"}

GROUP_RULES = [
    ("descent_system_structural_descent", re.compile(r"(^|/)lean/URF/DescentSystem\.lean$")),
    ("chronos_cert_entropy_determinism", re.compile(r"(^|/)lean/chronos_cert/ChronosCert\.lean$")),
    ("transport_entropy_set", re.compile(r"(^|/)chronos/Transport/VertexBoundaryTransport\.lean$")),
    ("provenance_codec", re.compile(r"(^|/)URFCore/Provenance\.lean$")),
    ("ci_idempotence_model", re.compile(r"(^|/)URFCore/CIIdempotence\.lean$")),
    ("urf_law3_global_information_axioms", re.compile(r"(^|/)urf_law3\.lean$")),
    ("admissible_normalization", re.compile(r"(^|/)admissible/lean/URFAdmissible\.lean$")),
    ("tree_toy_boundary_model", re.compile(r"(^|/)URF/Boundary/TreeToy\.lean$")),
    ("info_step_model", re.compile(r"(^|/)URF/Info/InfoAxioms\.lean$")),
    ("psh_bounded_overlap_model", re.compile(r"(^|/)URF/PSH/BoundedOverlap\.lean$")),
]

PATTERN = re.compile(r"\baxiom\b|\badmit\b|\bsorry\b")

def active_lean_files() -> list[Path]:
    files: list[Path] = []
    for root in SCAN_ROOTS:
        p = ROOT / root
        if not p.exists():
            continue
        if p.is_file() and p.suffix == ".lean":
            files.append(p)
            continue
        if p.is_dir():
            for f in p.rglob("*.lean"):
                rel_parts = set(f.relative_to(ROOT).parts)
                if rel_parts & EXCLUDED_PARTS:
                    continue
                files.append(f)
    return sorted(set(files))

def classify(rel: str) -> str:
    for name, rx in GROUP_RULES:
        if rx.search(rel):
            return name
    return "other_active_obligation"

def main() -> None:
    obligations = []
    for f in active_lean_files():
        rel = f.relative_to(ROOT).as_posix()
        if any(part in EXCLUDED_PARTS for part in Path(rel).parts):
            continue
        for i, line in enumerate(f.read_text(errors="ignore").splitlines(), start=1):
            if PATTERN.search(line):
                obligations.append({
                    "path": rel,
                    "line": i,
                    "group": classify(rel),
                    "text": line.strip(),
                })

    groups: dict[str, list[dict]] = {}
    for item in obligations:
        groups.setdefault(item["group"], []).append(item)

    data = {
        "status": "ACTIVE_OBLIGATION_GROUPS_ONLY_NO_THEOREM_CLOSURE",
        "date": "2026-05-26",
        "scope": "urf-core active repository files only",
        "excludes": sorted(EXCLUDED_PARTS),
        "total_active_obligations": len(obligations),
        "groups": {
            k: {
                "count": len(v),
                "paths": sorted({x["path"] for x in v}),
                "items": v,
            }
            for k, v in sorted(groups.items())
        },
        "does_not_prove": [
            "resolution of any axiom",
            "resolution of any admit",
            "resolution of any sorry",
            "global URF theorem closure",
            "unrestricted Chronos-RR",
            "unrestricted H4.1/FGL",
            "P vs NP",
            "any Clay problem",
        ],
    }

    ART.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")

    for item in data["groups"].values():
        for obligation in item["items"]:
            parts = set(Path(obligation["path"]).parts)
            assert ".lake" not in parts
            assert "legacy" not in parts
    assert data["total_active_obligations"] >= 0
    if data["total_active_obligations"] > 0:
        assert "descent_system_structural_descent" in data["groups"]
    assert "provenance_codec" not in data["groups"]
    assert data["status"].endswith("NO_THEOREM_CLOSURE")

    print("ACTIVE_OBLIGATION_GROUPS_OK")
    print(json.dumps({
        "total_active_obligations": data["total_active_obligations"],
        "groups": {k: v["count"] for k, v in data["groups"].items()},
    }, indent=2, sort_keys=True))

if __name__ == "__main__":
    main()
