from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay/pl_0005/replay.json")

def test_perelman_pl_0005_content_artifact():
    assert BASE.exists()
    data = json.loads(BASE.read_text(encoding="utf-8"))

    assert data["lemma_id"] == "PL-0005"
    assert data["status"] == "open"
    assert data["witness"].strip()
    assert len(data["assumptions"]) >= 3
    assert data["conclusion"].strip()
    assert data["dependency_inputs"] == ["PL-0004"]
    assert len(data["source_to_claim_map"]) >= 1
    assert data["source_to_claim_map"][0]["source"] == "perelman_2003_finite_extinction"
    assert data["source_to_claim_map"][0]["locator"] == "Section 93-95"
    assert len(data["local_verification_notes"]) >= 1
    assert len(data["open_gaps"]) >= 1

def test_perelman_pl_0005_content_doc():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0005_CONTENT.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\mathrm{PL\mbox{-}0005}" in text
    assert "replay.json" in text
