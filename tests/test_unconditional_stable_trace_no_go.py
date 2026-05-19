from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def test_unconditional_stable_trace_no_go_lean_surface():
    text = (ROOT / "lean/URF/Foundation/UnconditionalStableTraceNoGo.lean").read_text()
    assert "theorem no_unconditional_certificate_from_stable_trace" in text
    assert "theorem no_unconditional_certificate_exists_all_interfaces" in text
    assert "def noStableTraceCounterinterface" in text
    assert "theorem noStableTraceCountermodel_no_stableGenAdmissibleTrace" in text
    assert "theorem no_unconditional_stableGenAdmissibleTrace_all_interfaces" in text
    assert "theorem no_unconditional_joint_solution" in text


def test_unconditional_stable_trace_no_go_status_boundary():
    text = (ROOT / "docs/status/UNCONDITIONAL_STABLE_TRACE_NO_GO_2026_05_19.md").read_text()
    assert "Status: `REFUTED_UNCONDITIONAL_TARGET`" in text
    assert "The unconditional targets are false for arbitrary `CapacityInterface`." in text
    assert "Surviving conditional result:" in text
    assert "[Inhabited X.Trace]" in text
    assert "- unconditional `StableTraceCertificateExists`" in text
    assert "- unconditional `StableGenAdmissibleTrace`" in text
    assert "- unrestricted `UniversalFiberEntropyGap`" in text
    assert "- unrestricted Chronos-RR" in text
    assert "- unrestricted H4.1/FGL" in text
    assert "- P vs NP" in text
    assert "- any Clay problem" in text


def test_unconditional_stable_trace_no_go_artifact():
    data = json.loads((ROOT / "artifacts/urf/unconditional_stable_trace_no_go_2026_05_19.json").read_text())
    assert data["status"] == "REFUTED_UNCONDITIONAL_TARGET"
    assert "no unconditional StableGenAdmissibleTrace to StableTraceCertificateExists" in data["closed_no_go_results"]
    assert "unconditional StableGenAdmissibleTrace" in data["does_not_prove"]


def test_unconditional_stable_trace_no_go_imported():
    text = (ROOT / "lean/URF.lean").read_text()
    assert "import URF.Foundation.UnconditionalStableTraceNoGo" in text
