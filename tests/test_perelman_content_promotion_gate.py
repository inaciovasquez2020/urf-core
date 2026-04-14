from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(rel: str):
    return json.loads((BASE / rel).read_text(encoding="utf-8"))

def test_perelman_content_promotion_gate():
    closure = load("closure_report.json")
    p1 = load("pl_0001/replay.json")
    p2 = load("pl_0002/replay.json")
    p3 = load("pl_0003/replay.json")
    p4 = load("pl_0004/replay.json")
    p5 = load("pl_0005/replay.json")
    p6 = load("pl_0006/replay.json")

    artifacts = [p1, p2, p3, p4, p5, p6]

    for art in artifacts:
        assert art["status"] in {"open", "verified"}
        assert art["witness"].strip()
        assert len(art["assumptions"]) >= 1
        assert art["conclusion"].strip()
        assert len(art["source_to_claim_map"]) >= 1
        assert len(art["local_verification_notes"]) >= 1
        assert isinstance(art["open_gaps"], list)

    if closure["internal_verification"] == "internally_verified":
        for art in artifacts:
            assert art["status"] == "verified"
            assert art["open_gaps"] == []
            assert art["local_verification_notes"] == []
