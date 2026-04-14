from pathlib import Path
import json

def load(name: str):
    return json.loads(Path("artifacts/perelman_internal_replay", name).read_text(encoding="utf-8"))

def test_perelman_falsification_gate_on_internal_verification():
    closure = load("closure_report.json")
    source_index = load("source_index.json")
    lemma_map = load("lemma_map.json")
    dependency_dag = load("dependency_dag.json")
    gap_log = load("gap_log.json")

    v = closure["internal_verification"]

    assert v in {"not_internally_verified", "internally_verified"}

    if v == "internally_verified":
        assert closure["replay_complete"] is True
        assert source_index["status"] == "closed"
        assert lemma_map["status"] == "closed"
        assert dependency_dag["status"] == "closed"
        assert gap_log["status"] == "closed"
        assert gap_log.get("gaps", []) == []
    else:
        assert closure["replay_complete"] is False or gap_log["status"] != "closed"

def test_perelman_disproof_trigger_example():
    closure = load("closure_report.json")
    if closure["internal_verification"] == "internally_verified":
        assert closure["critical_variable"] == "internal_verification"
