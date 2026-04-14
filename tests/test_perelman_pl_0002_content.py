from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay/pl_0002/replay.json")

def test_perelman_pl_0002_content_artifact():
    assert BASE.exists()
    data = json.loads(BASE.read_text(encoding="utf-8"))

    assert data["lemma_id"] == "PL-0002"
    assert data["status"] == "open"
    assert data["witness"].strip()
    assert len(data["assumptions"]) >= 2
    assert data["conclusion"].strip()
    assert data["dependency_inputs"] == []
    assert len(data["source_to_claim_map"]) >= 1
    assert data["source_to_claim_map"][0]["source"] == "perelman_2002_entropy"
    assert data["source_to_claim_map"][0]["locator"] == "Section 26-27"
    assert len(data["local_verification_notes"]) >= 1
    assert len(data["open_gaps"]) >= 1

def test_perelman_pl_0002_content_doc():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0002_CONTENT.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\mathrm{PL\mbox{-}0002}" in text
    assert "replay.json" in text
