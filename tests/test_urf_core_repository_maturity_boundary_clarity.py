from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs/status/URF_CORE_REPOSITORY_MATURITY_BOUNDARY_CLARITY_2026_06_14.md"
LEDGER = ROOT / "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean"
CERT = ROOT / "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean"


def test_repository_maturity_boundary_clarity_doc_exists_and_links_surfaces():
    text = DOC.read_text()
    assert LEDGER.exists()
    assert CERT.exists()
    assert "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean" in text
    assert "lean/URF/Frontier/URFCoreMaturityBoundaryCertificate.lean" in text


def test_repository_maturity_boundary_clarity_boundary_tokens():
    text = DOC.read_text()
    assert "REPOSITORY_MATURITY_BOUNDARY_CLARITY_ONLY_NO_FINAL_THEOREM_CLOSURE" in text
    assert "URF_CORE_REPOSITORY_MATURITY_BOUNDARY_CLARITY" in text
    assert "NO_FINAL_THEOREM_CLOSURE_CLAIMED" in text
    assert "The final scientific theorem targets remain unproved here." in text


def test_repository_maturity_boundary_clarity_no_promotion_language():
    text = DOC.read_text()
    assert "final theorem closure is proved" not in text
    assert "proves URF scientific closure" not in text
    assert "proves Poincare" not in text
    assert "proves P vs NP" not in text
