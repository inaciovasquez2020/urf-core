from __future__ import annotations

from copy import deepcopy
from pathlib import Path
import json
import pytest


BASE = Path("artifacts/perelman_internal_replay")


def load(name: str):
    return json.loads((BASE / name).read_text(encoding="utf-8"))


def gate_assert(closure, source_index, lemma_map, dependency_dag, gap_log):
    v = closure["internal_verification"]

    assert closure["status"] in {"conditional", "closed"}
    assert closure["external_status"] == "solved"
    assert closure["solver"] == "Grigori Perelman"
    assert v in {"not_internally_verified", "internally_verified"}
    assert closure["critical_variable"] == "internal_verification"

    if v == "internally_verified":
        assert closure["replay_complete"] is True
        assert source_index["status"] == "closed"
        assert lemma_map["status"] == "closed"
        assert dependency_dag["status"] == "closed"
        assert gap_log["status"] == "closed"
        assert gap_log.get("gaps", []) == []
    else:
        assert (
            closure["replay_complete"] is False
            or source_index["status"] != "closed"
            or lemma_map["status"] != "closed"
            or dependency_dag["status"] != "closed"
            or gap_log["status"] != "closed"
            or gap_log.get("gaps", []) != []
        )


def make_verified_bundle():
    closure = load("closure_report.json")
    source_index = load("source_index.json")
    lemma_map = load("lemma_map.json")
    dependency_dag = load("dependency_dag.json")
    gap_log = load("gap_log.json")

    closure = deepcopy(closure)
    source_index = deepcopy(source_index)
    lemma_map = deepcopy(lemma_map)
    dependency_dag = deepcopy(dependency_dag)
    gap_log = deepcopy(gap_log)

    closure["status"] = "closed"
    closure["internal_verification"] = "internally_verified"
    closure["replay_complete"] = True
    closure["critical_variable"] = "internal_verification"

    source_index["status"] = "closed"
    lemma_map["status"] = "closed"
    dependency_dag["status"] = "closed"
    gap_log["status"] = "closed"
    gap_log["gaps"] = []

    return closure, source_index, lemma_map, dependency_dag, gap_log


def test_repository_current_state_is_admissible():
    gate_assert(
        load("closure_report.json"),
        load("source_index.json"),
        load("lemma_map.json"),
        load("dependency_dag.json"),
        load("gap_log.json"),
    )


def test_verified_bundle_passes():
    gate_assert(*make_verified_bundle())


@pytest.mark.parametrize(
    "mutator",
    [
        lambda c, s, l, d, g: c.__setitem__("replay_complete", False),
        lambda c, s, l, d, g: s.__setitem__("status", "open"),
        lambda c, s, l, d, g: l.__setitem__("status", "open"),
        lambda c, s, l, d, g: d.__setitem__("status", "open"),
        lambda c, s, l, d, g: g.__setitem__("status", "open"),
        lambda c, s, l, d, g: g.__setitem__("gaps", ["unresolved gap"]),
        lambda c, s, l, d, g: c.__setitem__("critical_variable", "solver"),
    ],
)
def test_each_single_falsifier_blocks_internal_verification(mutator):
    closure, source_index, lemma_map, dependency_dag, gap_log = make_verified_bundle()
    mutator(closure, source_index, lemma_map, dependency_dag, gap_log)

    with pytest.raises(AssertionError):
        gate_assert(closure, source_index, lemma_map, dependency_dag, gap_log)


def test_not_internally_verified_state_requires_some_open_object():
    closure, source_index, lemma_map, dependency_dag, gap_log = make_verified_bundle()
    closure["internal_verification"] = "not_internally_verified"
    closure["status"] = "conditional"
    closure["replay_complete"] = False
    gap_log["status"] = "open"
    gap_log["gaps"] = ["open replay item"]

    gate_assert(closure, source_index, lemma_map, dependency_dag, gap_log)


def test_false_promotion_is_rejected():
    closure = load("closure_report.json")
    source_index = load("source_index.json")
    lemma_map = load("lemma_map.json")
    dependency_dag = load("dependency_dag.json")
    gap_log = load("gap_log.json")

    closure = deepcopy(closure)
    closure["internal_verification"] = "internally_verified"

    with pytest.raises(AssertionError):
        gate_assert(closure, source_index, lemma_map, dependency_dag, gap_log)
