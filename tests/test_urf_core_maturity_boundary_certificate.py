from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean"


def test_urf_core_maturity_boundary_certificate_surface_tokens():
    text = LEAN.read_text()
    assert "structure URFCoreMaturityBoundaryCertificate" in text
    assert "def URFCoreMaturityBoundaryCertificateWellFormed" in text
    assert "theorem URFCoreMaturityBoundaryCertificateSurface" in text
    assert "URF_CORE_MATURITY_BOUNDARY_CERTIFICATE" in text


def test_urf_core_maturity_boundary_certificate_boundary_tokens():
    text = LEAN.read_text()
    assert "MATURITY_BOUNDARY_CERTIFICATE_ONLY_NO_FINAL_THEOREM_CLOSURE" in text
    assert "NO_FINAL_THEOREM_CLOSURE_CLAIMED" in text
    assert "It does not prove URF scientific" in text


def test_urf_core_maturity_boundary_certificate_no_forbidden_tokens():
    text = LEAN.read_text()
    assert "axiom " not in text
    assert "opaque " not in text
    assert "sorry" not in text
    assert "admit" not in text
