from pathlib import Path
import json

def test_perelman_internal_replay_artifact_lock():
    status = Path("docs/status/PERELMAN_INTERNAL_REPLAY_STATUS.md").read_text(encoding="utf-8")
    manifest = Path("artifacts/perelman_internal_replay/REPLAY_MANIFEST.md").read_text(encoding="utf-8")

    assert "Conditional." in status
    assert "Conditional." in manifest
    assert r"\text{External status}=\text{Solved}." in status
    assert r"\text{Toolkit replay artifact}=\text{Present}." in status
    assert r"\text{Internal replay status}=\texttt{Declared\ Artifact / Verification\ Open}." in status
    assert r"\text{Internal verification status}=\texttt{Not\ Internally\ Verified}." in status
    assert r"\text{Target}=\text{Poincaré Conjecture original solve}." in manifest
    assert r"\text{Replay status}=\texttt{Declared\ Artifact / Verification\ Open}." in manifest
    assert r"\text{Internal verification status}=\texttt{Not\ Internally\ Verified}." in manifest

def test_perelman_internal_replay_json_objects():
    base = Path("artifacts/perelman_internal_replay")
    source_index = json.loads((base / "source_index.json").read_text(encoding="utf-8"))
    lemma_map = json.loads((base / "lemma_map.json").read_text(encoding="utf-8"))
    dependency_dag = json.loads((base / "dependency_dag.json").read_text(encoding="utf-8"))
    gap_log = json.loads((base / "gap_log.json").read_text(encoding="utf-8"))
    closure_report = json.loads((base / "closure_report.json").read_text(encoding="utf-8"))

    assert source_index["status"] == "open"
    assert lemma_map["status"] == "open"
    assert dependency_dag["status"] == "open"
    assert gap_log["status"] == "open"
    assert closure_report["status"] == "conditional"
    assert closure_report["internal_verification"] == "not_internally_verified"
    assert closure_report["external_status"] == "solved"
    assert closure_report["solver"] == "Grigori Perelman"
