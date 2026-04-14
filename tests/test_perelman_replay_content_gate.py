from __future__ import annotations

from pathlib import Path
import json
import re

BASE = Path("artifacts/perelman_internal_replay")


def load(name: str):
    return json.loads((BASE / name).read_text(encoding="utf-8"))


PLACEHOLDER_PATTERNS = [
    r"^\s*$",
    r"TODO",
    r"placeholder",
    r"Root theorem node\.",
]


def has_placeholder(text: str) -> bool:
    return any(re.search(p, text, flags=re.IGNORECASE) for p in PLACEHOLDER_PATTERNS)


def test_perelman_replay_sources_are_nonempty():
    data = load("sources.json")
    assert data["status"] in {"open", "closed"}
    sources = data["sources"]
    assert len(sources) >= 5
    for src in sources:
        assert src["id"].strip()
        assert src["title"].strip()
        assert src["kind"].strip()
        assert src["locator"].strip()


def test_perelman_replay_lemmas_have_real_content():
    data = load("lemmas.json")
    lemmas = data["lemmas"]
    assert len(lemmas) >= 6

    for lemma in lemmas:
        assert lemma["id"].strip()
        assert lemma["section"].strip()
        assert lemma["source"].strip()
        assert lemma["source_locator"].strip(), f"empty source_locator in {lemma['id']}"
        assert lemma["statement"].strip(), f"empty statement in {lemma['id']}"
        assert not has_placeholder(lemma["statement"]), f"placeholder statement in {lemma['id']}"
        assert not has_placeholder(lemma["notes"]), f"placeholder notes in {lemma['id']}"


def test_perelman_gap_ledger_matches_actual_missing_content():
    lemmas = load("lemmas.json")["lemmas"]
    gaps = load("gaps.json")["gaps"]
    gap_ids = {g["lemma_id"] for g in gaps if g["status"] == "open"}

    for lemma in lemmas:
        missing_content = (
            not lemma["statement"].strip()
            or not lemma["source_locator"].strip()
            or has_placeholder(lemma["statement"])
            or has_placeholder(lemma["notes"])
        )
        if missing_content:
            assert lemma["id"] in gap_ids, f"missing open gap for {lemma['id']}"


def test_internal_verification_blocked_by_placeholder_content():
    closure = load("closure_report.json")
    lemmas = load("lemmas.json")["lemmas"]

    if closure["internal_verification"] == "internally_verified":
        for lemma in lemmas:
            assert lemma["statement"].strip()
            assert lemma["source_locator"].strip()
            assert not has_placeholder(lemma["statement"])
            assert not has_placeholder(lemma["notes"])
