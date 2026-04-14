from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay/pl_0006/replay.json")

def test_perelman_pl_0006_content_artifact():
    assert BASE.exists()
    data = json.loads(BASE.read_text(encoding="utf-8"))

    assert data["lemma_id"] == "PL-0006"
    assert data["status"] == "open"
    assert data["witness"].strip()
    assert len(data["assumptions"]) >= 3
    assert data["conclusion"].strip()
    assert data["dependency_inputs"] == ["PL-0005"]
    assert len(data["source_to_claim_map"]) >= 1
    assert data["source_to_claim_map"][0]["source"] == "morgan_tian"
    assert data["source_to_claim_map"][0]["locator"] == "Section 98-100"
    assert len(data["local_verification_notes"]) >= 1
    assert len(data["open_gaps"]) >= 1

def test_perelman_pl_0006_content_doc():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0006_CONTENT.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\mathrm{PL\mbox{-}0006}" in text
    assert "replay.json" in text
