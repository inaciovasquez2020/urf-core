from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "lean/URF/Frontier/BoundedFrontierMissingLemmaLedger.lean"


def test_urf_bounded_frontier_missing_lemma_ledger_surface_tokens():
    text = LEAN.read_text()
    assert "structure BoundedFrontierMissingLemmaLedgerEntry" in text
    assert "def BoundedFrontierMissingLemmaLedgerWellFormed" in text
    assert "theorem URFBoundedFrontierMissingLemmaLedgerSurface" in text
    assert "URF_BOUNDED_FRONTIER_MISSING_LEMMA_LEDGER" in text


def test_urf_bounded_frontier_missing_lemma_ledger_boundary_tokens():
    text = LEAN.read_text()
    assert "LEDGER_SURFACE_ONLY_NO_FINAL_THEOREM_CLOSURE" in text
    assert "NO_FINAL_THEOREM_CLOSURE_CLAIMED" in text
    assert "It does not prove the flagship object" in text


def test_urf_bounded_frontier_missing_lemma_ledger_no_forbidden_tokens():
    text = LEAN.read_text()
    assert "axiom " not in text
    assert "opaque " not in text
    assert "sorry" not in text
    assert "admit" not in text
