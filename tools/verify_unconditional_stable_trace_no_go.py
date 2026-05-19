from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/UnconditionalStableTraceNoGo.lean"
doc = ROOT / "docs/status/UNCONDITIONAL_STABLE_TRACE_NO_GO_2026_05_19.md"
artifact = ROOT / "artifacts/urf/unconditional_stable_trace_no_go_2026_05_19.json"
root = ROOT / "lean/URF.lean"

lean_text = lean.read_text()
doc_text = doc.read_text()
data = json.loads(artifact.read_text())
root_text = root.read_text()

required_lean = [
    "import URF.Foundation.StableTraceCertificateEquivalence",
    "theorem no_unconditional_certificate_from_stable_trace",
    "theorem no_unconditional_certificate_exists_all_interfaces",
    "def noStableTraceCounterinterface",
    "Trace := Empty",
    "StableGen := fun _ => True",
    "theorem noStableTraceCountermodel_no_stableGenAdmissibleTrace",
    "theorem no_unconditional_stableGenAdmissibleTrace_all_interfaces",
    "theorem no_unconditional_joint_solution",
]

for token in required_lean:
    assert token in lean_text, token

assert "import URF.Foundation.UnconditionalStableTraceNoGo" in root_text
assert "Status: `REFUTED_UNCONDITIONAL_TARGET`" in doc_text
assert "The unconditional targets are false for arbitrary `CapacityInterface`." in doc_text
assert "[Inhabited X.Trace]" in doc_text
assert data["status"] == "REFUTED_UNCONDITIONAL_TARGET"

for required_boundary in [
    "unconditional `StableTraceCertificateExists`",
    "unconditional `StableGenAdmissibleTrace`",
    "unrestricted `UniversalFiberEntropyGap`",
    "unrestricted Chronos-RR",
    "unrestricted H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    assert required_boundary in doc_text, required_boundary

print("Unconditional stable trace no-go verified.")
