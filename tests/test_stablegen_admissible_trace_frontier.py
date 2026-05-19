from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def test_stablegen_admissible_trace_frontier_lean_surface():
    text = (ROOT / "lean/URF/Foundation/StableGenAdmissibleTraceFrontier.lean").read_text()
    assert "structure StableTraceCertificate" in text
    assert "def StableTraceCertificateExists" in text
    assert "theorem stableGenAdmissibleTrace_from_certificate" in text
    assert "theorem capacitySoundness_from_certificate" in text
    assert "theorem capacityObstruction_from_certificate" in text


def test_stablegen_admissible_trace_frontier_status_boundary():
    text = (ROOT / "docs/status/STABLEGEN_ADMISSIBLE_TRACE_FRONTIER_2026_05_19.md").read_text()
    assert "Status: `FRONTIER_OPEN / CERTIFICATE_INTERFACE_ONLY`" in text
    assert "Unique open object:" in text
    assert "- construction of `StableTraceCertificate`" in text
    assert "- equivalently, proof of `StableGenAdmissibleTrace`" in text
    assert "Does not prove:" in text
    assert "- `StableTraceCertificateExists`" in text
    assert "- `StableGenAdmissibleTrace`" in text
    assert "- unrestricted `UniversalFiberEntropyGap`" in text
    assert "- unrestricted Chronos-RR" in text
    assert "- unrestricted H4.1/FGL" in text
    assert "- P vs NP" in text
    assert "- any Clay problem" in text


def test_stablegen_admissible_trace_frontier_artifact():
    data = json.loads((ROOT / "artifacts/urf/stablegen_admissible_trace_frontier_2026_05_19.json").read_text())
    assert data["status"] == "FRONTIER_OPEN / CERTIFICATE_INTERFACE_ONLY"
    assert "StableTraceCertificateExists" in data["unique_open_objects"]
    assert "StableGenAdmissibleTrace" in data["unique_open_objects"]
    assert "certificate implies CapacitySoundness" in data["closed_structural_steps"]


def test_stablegen_admissible_trace_frontier_imported():
    text = (ROOT / "lean/URF.lean").read_text()
    assert "import URF.Foundation.StableGenAdmissibleTraceFrontier" in text
