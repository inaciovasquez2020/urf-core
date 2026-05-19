from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/StableGenAdmissibleTraceFrontier.lean"
doc = ROOT / "docs/status/STABLEGEN_ADMISSIBLE_TRACE_FRONTIER_2026_05_19.md"
artifact = ROOT / "artifacts/urf/stablegen_admissible_trace_frontier_2026_05_19.json"
root = ROOT / "lean/URF.lean"

lean_text = lean.read_text()
doc_text = doc.read_text()
data = json.loads(artifact.read_text())
root_text = root.read_text()

required_lean = [
    "import URF.Foundation.CapacitySoundnessReduction",
    "structure StableTraceCertificate",
    "traceOf : X.Generator → X.Trace",
    "admissible : ∀ g : X.Generator",
    "encodes : ∀ g : X.Generator",
    "def StableTraceCertificateExists",
    "theorem stableGenAdmissibleTrace_from_certificate",
    "theorem stableGenAdmissibleTrace_from_certificate_exists",
    "theorem capacitySoundness_from_certificate",
    "theorem capacityObstruction_from_certificate",
]

for token in required_lean:
    assert token in lean_text, token

assert "import URF.Foundation.StableGenAdmissibleTraceFrontier" in root_text
assert "Status: `FRONTIER_OPEN / CERTIFICATE_INTERFACE_ONLY`" in doc_text
assert "Unique open object:" in doc_text
assert "- construction of `StableTraceCertificate`" in doc_text
assert "- equivalently, proof of `StableGenAdmissibleTrace`" in doc_text
assert data["status"] == "FRONTIER_OPEN / CERTIFICATE_INTERFACE_ONLY"
assert "StableTraceCertificateExists" in data["unique_open_objects"]
assert "StableGenAdmissibleTrace" in data["unique_open_objects"]

for forbidden in [
    "proves StableTraceCertificateExists",
    "proves StableGenAdmissibleTrace",
    "proves unrestricted UniversalFiberEntropyGap",
    "proves unrestricted Chronos-RR",
    "proves unrestricted H4.1/FGL",
    "proves P vs NP",
    "proves any Clay problem",
]:
    assert forbidden not in lean_text
    assert forbidden not in doc_text

print("StableGenAdmissibleTrace frontier verified.")
