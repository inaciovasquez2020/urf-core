from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay/pl_0001/replay.json")

def test_perelman_pl_0001_content_artifact():
    assert BASE.exists()
    data = json.loads(BASE.read_text(encoding="utf-8"))

    assert data["lemma_id"] == "PL-0001"
    assert data["status"] == "open"
    assert data["witness"].strip()
    assert len(data["assumptions"]) >= 6
    assert data["conclusion"].strip()
    assert data["dependency_inputs"] == ["PL-0002", "PL-0003", "PL-0004", "PL-0005", "PL-0006"]
    assert len(data["source_to_claim_map"]) >= 1
    assert data["source_to_claim_map"][0]["source"] == "morgan_tian"
    assert data["source_to_claim_map"][0]["locator"] == "global"
    assert len(data["local_verification_notes"]) >= 1
    assert len(data["open_gaps"]) >= 1

def test_perelman_pl_0001_content_doc():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0001_CONTENT.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\mathrm{PL\mbox{-}0001}" in text
    assert "replay.json" in text
