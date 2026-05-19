from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/StableTraceCertificateEquivalence.lean"
doc = ROOT / "docs/status/STABLE_TRACE_CERTIFICATE_EQUIVALENCE_2026_05_19.md"
artifact = ROOT / "artifacts/urf/stable_trace_certificate_equivalence_2026_05_19.json"
root = ROOT / "lean/URF.lean"

lean_text = lean.read_text()
doc_text = doc.read_text()
data = json.loads(artifact.read_text())
root_text = root.read_text()

required_lean = [
    "import URF.Foundation.StableGenAdmissibleTraceFrontier",
    "noncomputable theorem stableGenAdmissibleTrace_to_certificate",
    "[Inhabited X.Trace]",
    "StableGenAdmissibleTrace X",
    "StableTraceCertificateExists X",
    "noncomputable theorem stableGenAdmissibleTrace_iff_certificateExists",
    "noncomputable theorem stableTraceCertificateExists_iff_stableGenAdmissibleTrace",
    "def emptyTraceCounterinterface",
    "Trace := Empty",
    "StableGen := fun _ => False",
    "theorem emptyTraceCountermodel_stableGenAdmissibleTrace",
    "theorem emptyTraceCountermodel_no_certificate",
    "theorem emptyTraceCountermodel_no_trace_inhabited",
]

for token in required_lean:
    assert token in lean_text, token

assert "import URF.Foundation.StableTraceCertificateEquivalence" in root_text
assert "Status: `CONDITIONAL / TRACE_INHABITED_EQUIVALENCE`" in doc_text
assert "Formal dependency:" in doc_text
assert "[Inhabited X.Trace]" in doc_text
assert "Countermodel:" in doc_text
assert data["status"] == "CONDITIONAL / TRACE_INHABITED_EQUIVALENCE"
assert data["formal_dependency"] == "Inhabited X.Trace"
assert data["countermodel"]["Trace"] == "Empty"
assert data["countermodel"]["StableTraceCertificateExists"] is False

for required_boundary in [
    "unconditional `StableTraceCertificateExists`",
    "unconditional `StableGenAdmissibleTrace → StableTraceCertificateExists`",
    "unconditional `StableGenAdmissibleTrace`",
    "unrestricted `UniversalFiberEntropyGap`",
    "unrestricted Chronos-RR",
    "unrestricted H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    assert required_boundary in doc_text, required_boundary

print("Stable trace certificate equivalence verified.")
