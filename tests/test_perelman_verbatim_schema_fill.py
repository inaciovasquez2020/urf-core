from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(rel: str):
    return json.loads((BASE / rel).read_text(encoding="utf-8"))

def test_perelman_verbatim_schema_fill():
    for rel in [
        "pl_0001/replay.json",
        "pl_0002/replay.json",
        "pl_0003/replay.json",
        "pl_0004/replay.json",
        "pl_0005/replay.json",
        "pl_0006/replay.json",
    ]:
        art = load(rel)
        assert "verbatim_source_excerpt" in art
        assert "normalized_statement" in art
        assert "normalization_notes" in art
        assert isinstance(art["verbatim_source_excerpt"], str)
        assert isinstance(art["normalized_statement"], str)
        assert isinstance(art["normalization_notes"], list)
