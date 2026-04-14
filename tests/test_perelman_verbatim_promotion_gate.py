from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(rel: str):
    return json.loads((BASE / rel).read_text(encoding="utf-8"))

def test_perelman_verbatim_promotion_gate():
    closure = load("closure_report.json")
    artifacts = [
        load("pl_0001/replay.json"),
        load("pl_0002/replay.json"),
        load("pl_0003/replay.json"),
        load("pl_0004/replay.json"),
        load("pl_0005/replay.json"),
        load("pl_0006/replay.json"),
    ]

    for art in artifacts:
        assert art["lemma_id"].startswith("PL-")
        assert art["status"] in {"open", "verified"}

    if closure["internal_verification"] == "internally_verified":
        for art in artifacts:
            assert art["status"] == "verified"
            assert "verbatim_source_excerpt" in art
            assert "normalized_statement" in art
            assert "normalization_notes" in art
            assert str(art["verbatim_source_excerpt"]).strip()
            assert str(art["normalized_statement"]).strip()
