#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

ARTIFACT = Path("artifacts/urf/gravity_qft_classical_limit_source_map_2026_06_18.json")
STATUS = Path("docs/status/GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_2026_06_18.md")
LEAN = Path("lean/URF/Frontier/EmergentMetricClassicalLimitSource.lean")

ALLOWED = {
    "formalization_template",
    "semiclassical_limit_input",
    "curved_spacetime_context",
    "emergent_metric_target",
    "approximation_method",
}

FORBIDDEN_TOKENS = {
    "solves_gravity",
    "quantum_gravity_closed",
    "Einstein_limit_proved",
    "experimental_confirmation",
}

REQUIRED_KEYS = {
    "douglas_hoback_mei_nissim_2026_formalization_qft",
    "hutsalyuk_lajer_mussardo_stampiggi_2026_variational_qft",
    "qft_curved_spacetime_lisbon_2026",
    "helland_parthasarathy_2026_theoretical_variables",
    "coarse_grained_classical_limit_2025",
    "nagy_2025_classical_limit_scalar_qft",
    "volovik_2026_quantum_classical_mechanics_vs_qft",
}


def fail(message: str) -> None:
    raise SystemExit(f"GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_FAIL: {message}")


def require_path(path: Path) -> str:
    if not path.exists():
        fail(f"missing {path}")
    return path.read_text()


def has_citation(citation: object) -> bool:
    if not isinstance(citation, dict):
        return False
    url = citation.get("url")
    if not isinstance(url, str) or not url.startswith("https://"):
        return False
    identifier = citation.get("doi") or citation.get("arxiv_id") or citation.get("url")
    return isinstance(identifier, str) and bool(identifier.strip())


def main() -> None:
    raw = require_path(ARTIFACT)
    status_text = require_path(STATUS)
    lean_text = require_path(LEAN)

    data = json.loads(raw)

    if data.get("status") != "conditional_source_map_only":
        fail("artifact status must remain conditional_source_map_only")

    if data.get("boundary") != "BOUNDARY := ¬ solved_quantum_gravity":
        fail("boundary must be exactly recorded")

    does_not_claim = data.get("does_not_claim")
    if not isinstance(does_not_claim, dict):
        fail("does_not_claim object missing")

    for token in FORBIDDEN_TOKENS:
        if does_not_claim.get(token) is not False:
            fail(f"closure guard must reject {token}")

    allowed = set(data.get("allowed_classifications", []))
    if allowed != ALLOWED:
        fail("allowed classification set changed")

    references = data.get("references")
    if not isinstance(references, list):
        fail("references must be a list")

    keys = {entry.get("key") for entry in references if isinstance(entry, dict)}
    if keys != REQUIRED_KEYS:
        fail("reference key set changed")

    seen_classes = set()
    for entry in references:
        if not isinstance(entry, dict):
            fail("reference entry must be an object")
        classification = entry.get("classification")
        if classification not in ALLOWED:
            fail(f"bad classification for {entry.get('key')}")
        seen_classes.add(classification)
        if not has_citation(entry.get("citation")):
            fail(f"missing citation for {entry.get('key')}")
        boundary = entry.get("boundary")
        if not isinstance(boundary, str):
            fail(f"missing boundary note for {entry.get('key')}")
        boundary_lower = boundary.lower()
        if "no " not in boundary_lower and "does not" not in boundary_lower:
            fail(f"missing boundary note for {entry.get('key')}")

    if seen_classes != ALLOWED:
        fail("not all allowed classifications are represented")

    for path, text in ((ARTIFACT, raw), (STATUS, status_text), (LEAN, lean_text)):
        for token in FORBIDDEN_TOKENS:
            if token in text and path != ARTIFACT:
                fail(f"forbidden closure token {token} found in {path}")

    if "BOUNDARY := ¬ solved_quantum_gravity" not in status_text:
        fail("status boundary missing")

    if "structure EmergentMetricClassicalLimitSource" not in lean_text:
        fail("Lean source surface missing")

    if "sorry" in lean_text or "axiom" in lean_text or "admit" in lean_text or "opaque" in lean_text:
        fail("Lean source contains forbidden proof marker")

    print("GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_OK")


if __name__ == "__main__":
    main()
