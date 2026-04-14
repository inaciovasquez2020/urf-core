from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(rel: str):
    return json.loads((BASE / rel).read_text(encoding="utf-8"))

def test_perelman_replay_content_chain():
    p1 = load("pl_0001/replay.json")
    p2 = load("pl_0002/replay.json")
    p3 = load("pl_0003/replay.json")
    p4 = load("pl_0004/replay.json")
    p5 = load("pl_0005/replay.json")
    p6 = load("pl_0006/replay.json")

    assert p1["lemma_id"] == "PL-0001"
    assert p2["lemma_id"] == "PL-0002"
    assert p3["lemma_id"] == "PL-0003"
    assert p4["lemma_id"] == "PL-0004"
    assert p5["lemma_id"] == "PL-0005"
    assert p6["lemma_id"] == "PL-0006"

    assert p1["dependency_inputs"] == ["PL-0002", "PL-0003", "PL-0004", "PL-0005", "PL-0006"]
    assert p2["dependency_inputs"] == []
    assert p3["dependency_inputs"] == ["PL-0002"]
    assert p4["dependency_inputs"] == ["PL-0002", "PL-0003"]
    assert p5["dependency_inputs"] == ["PL-0004"]
    assert p6["dependency_inputs"] == ["PL-0005"]

    assert p2["source_to_claim_map"][0]["source"] == "perelman_2002_entropy"
    assert p3["source_to_claim_map"][0]["source"] == "perelman_2003_surgery"
    assert p4["source_to_claim_map"][0]["source"] == "perelman_2003_surgery"
    assert p5["source_to_claim_map"][0]["source"] == "perelman_2003_finite_extinction"
    assert p6["source_to_claim_map"][0]["source"] == "morgan_tian"
    assert p1["source_to_claim_map"][0]["source"] == "morgan_tian"
