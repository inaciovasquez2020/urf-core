from pathlib import Path
import json
BASE = Path("artifacts/perelman_internal_replay/pl_0006/replay.json")
def test_perelman_pl_0006_verbatim_fill():
    data = json.loads(BASE.read_text(encoding="utf-8"))
    assert data["lemma_id"] == "PL-0006"
    assert "verbatim_source_excerpt" in data
    assert "normalized_statement" in data
    assert "normalization_notes" in data
    assert data["normalized_statement"].strip()
    assert isinstance(data["normalization_notes"], list)
    assert len(data["normalization_notes"]) >= 1
