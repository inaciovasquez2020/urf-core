from pathlib import Path
import json

BASE = Path("artifacts/perelman_internal_replay")

def load(name: str):
    return json.loads((BASE / name).read_text(encoding="utf-8"))

def test_root_promotion_gate():
    root = Path("docs/math/PERELMAN_REPLAY_PL_0001.md").read_text(encoding="utf-8")
    closure = load("closure_report.json")
    lemmas = load("lemmas.json")["lemmas"]
    gaps = load("gaps.json")["gaps"]

    assert r"\mathrm{PL\mbox{-}0002}" in root
    assert r"\mathrm{PL\mbox{-}0003}" in root
    assert r"\mathrm{PL\mbox{-}0004}" in root
    assert r"\mathrm{PL\mbox{-}0005}" in root
    assert r"\mathrm{PL\mbox{-}0006}" in root

    if closure["internal_verification"] == "internally_verified":
        statuses = {lemma["id"]: lemma["status"] for lemma in lemmas}
        assert statuses["PL-0001"] == "verified"
        assert statuses["PL-0002"] == "verified"
        assert statuses["PL-0003"] == "verified"
        assert statuses["PL-0004"] == "verified"
        assert statuses["PL-0005"] == "verified"
        assert statuses["PL-0006"] == "verified"
        assert gaps == []
