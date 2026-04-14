from __future__ import annotations

from pathlib import Path
import json


BASE = Path("artifacts/perelman_internal_replay")


def load(name: str):
    return json.loads((BASE / name).read_text(encoding="utf-8"))


def test_replay_files_exist():
    assert (BASE / "sources.json").exists()
    assert (BASE / "lemmas.json").exists()
    assert (BASE / "gaps.json").exists()
    assert (BASE / "closure_report.json").exists()
    assert Path("docs/math/PERELMAN_LEMMA_BY_LEMMA_REPLAY_PROTOCOL.md").exists()


def test_lemma_schema_and_unique_ids():
    data = load("lemmas.json")
    lemmas = data["lemmas"]
    ids = set()
    allowed = {"open", "replayed", "blocked", "verified"}
    for lemma in lemmas:
        assert set(lemma.keys()) == {
            "id",
            "section",
            "statement",
            "source",
            "source_locator",
            "dependencies",
            "status",
            "notes",
        }
        assert lemma["id"] not in ids
        ids.add(lemma["id"])
        assert lemma["status"] in allowed
        assert isinstance(lemma["dependencies"], list)


def test_sources_cover_all_lemma_sources():
    sources = load("sources.json")["sources"]
    source_ids = {s["id"] for s in sources}
    lemmas = load("lemmas.json")["lemmas"]
    for lemma in lemmas:
        assert lemma["source"] in source_ids


def test_dependency_dag_is_well_formed_and_acyclic():
    lemmas = load("lemmas.json")["lemmas"]
    ids = {lemma["id"] for lemma in lemmas}
    deps = {lemma["id"]: lemma["dependencies"] for lemma in lemmas}
    for lemma_id, children in deps.items():
        for child in children:
            assert child in ids
            assert child != lemma_id

    temp = set()
    perm = set()

    def visit(node: str):
        assert node not in temp
        if node in perm:
            return
        temp.add(node)
        for child in deps[node]:
            visit(child)
        temp.remove(node)
        perm.add(node)

    for node in ids:
        visit(node)


def test_gap_ledger_references_known_lemmas():
    lemma_ids = {lemma["id"] for lemma in load("lemmas.json")["lemmas"]}
    gaps = load("gaps.json")["gaps"]
    for gap in gaps:
        assert gap["lemma_id"] in lemma_ids
        assert gap["status"] == "open"


def test_internal_verification_promotion_rule():
    closure = load("closure_report.json")
    lemmas = load("lemmas.json")["lemmas"]
    gaps = load("gaps.json")["gaps"]

    assert closure["external_status"] == "solved"
    assert closure["solver"] == "Grigori Perelman"
    assert closure["critical_variable"] == "internal_verification"
    assert closure["internal_verification"] in {
        "not_internally_verified",
        "internally_verified",
    }

    if closure["internal_verification"] == "internally_verified":
        assert closure["replay_complete"] is True
        assert all(lemma["status"] == "verified" for lemma in lemmas)
        assert gaps == []
    else:
        assert (
            closure["replay_complete"] is False
            or any(lemma["status"] != "verified" for lemma in lemmas)
            or gaps != []
        )


def test_replay_root_exists():
    lemmas = load("lemmas.json")["lemmas"]
    roots = [lemma for lemma in lemmas if lemma["dependencies"] == []]
    assert any(lemma["id"] == "PL-0001" for lemma in roots)
