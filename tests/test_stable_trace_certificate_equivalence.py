from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]


def test_stable_trace_certificate_equivalence_lean_surface():
    text = (ROOT / "lean/URF/Foundation/StableTraceCertificateEquivalence.lean").read_text()
    assert "noncomputable theorem stableGenAdmissibleTrace_to_certificate" in text
    assert "[Inhabited X.Trace]" in text
    assert "noncomputable theorem stableGenAdmissibleTrace_iff_certificateExists" in text
    assert "noncomputable theorem stableTraceCertificateExists_iff_stableGenAdmissibleTrace" in text
    assert "def emptyTraceCounterinterface" in text
    assert "theorem emptyTraceCountermodel_no_certificate" in text


def test_stable_trace_certificate_equivalence_status_boundary():
    text = (ROOT / "docs/status/STABLE_TRACE_CERTIFICATE_EQUIVALENCE_2026_05_19.md").read_text()
    assert "Status: `CONDITIONAL / TRACE_INHABITED_EQUIVALENCE`" in text
    assert "Formal dependency:" in text
    assert "[Inhabited X.Trace]" in text
    assert "Countermodel:" in text
    assert "- unconditional `StableTraceCertificateExists`" in text
    assert "- unconditional `StableGenAdmissibleTrace → StableTraceCertificateExists`" in text
    assert "- unconditional `StableGenAdmissibleTrace`" in text
    assert "- unrestricted `UniversalFiberEntropyGap`" in text
    assert "- unrestricted Chronos-RR" in text
    assert "- unrestricted H4.1/FGL" in text
    assert "- P vs NP" in text
    assert "- any Clay problem" in text


def test_stable_trace_certificate_equivalence_artifact():
    data = json.loads((ROOT / "artifacts/urf/stable_trace_certificate_equivalence_2026_05_19.json").read_text())
    assert data["status"] == "CONDITIONAL / TRACE_INHABITED_EQUIVALENCE"
    assert data["formal_dependency"] == "Inhabited X.Trace"
    assert data["countermodel"]["Trace"] == "Empty"
    assert data["countermodel"]["StableGenAdmissibleTrace"] is True
    assert data["countermodel"]["StableTraceCertificateExists"] is False


def test_stable_trace_certificate_equivalence_imported():
    text = (ROOT / "lean/URF.lean").read_text()
    assert "import URF.Foundation.StableTraceCertificateEquivalence" in text
