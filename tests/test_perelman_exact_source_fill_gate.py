from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(rel: str):
    return json.loads((BASE / rel).read_text(encoding="utf-8"))

def test_perelman_exact_source_fill_gate():
    for rel, lemma_id in [
        ("pl_0001/replay.json", "PL-0001"),
        ("pl_0002/replay.json", "PL-0002"),
        ("pl_0003/replay.json", "PL-0003"),
        ("pl_0004/replay.json", "PL-0004"),
        ("pl_0005/replay.json", "PL-0005"),
        ("pl_0006/replay.json", "PL-0006"),
    ]:
        data = load(rel)
        assert data["lemma_id"] == lemma_id
        assert "verbatim_source_excerpt" in data
        assert "normalized_statement" in data
        assert "normalization_notes" in data
        assert data["verbatim_source_excerpt"].strip()
        assert data["normalized_statement"].strip()
        assert isinstance(data["normalization_notes"], list)
        assert len(data["normalization_notes"]) >= 1
