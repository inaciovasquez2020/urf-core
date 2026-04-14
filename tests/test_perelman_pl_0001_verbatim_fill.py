from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay/pl_0001/replay.json")

def test_perelman_pl_0001_verbatim_fill():
    data = json.loads(BASE.read_text(encoding="utf-8"))
    assert data["lemma_id"] == "PL-0001"
    assert "verbatim_source_excerpt" in data
    assert "normalized_statement" in data
    assert "normalization_notes" in data
    assert data["normalized_statement"].strip()
    assert isinstance(data["normalization_notes"], list)
    assert len(data["normalization_notes"]) >= 1
