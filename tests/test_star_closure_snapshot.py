from pathlib import Path

def test_star_closure_snapshot():
    text = Path("docs/status/STAR_CLOSURE_SNAPSHOT.md").read_text(encoding="utf-8")
    assert "# Star Closure Snapshot" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Locked objects on main" in text
    assert "## Certified chain status" in text
    assert "## Exact theorem status" in text
    assert "## Terminal missing object" in text
    assert "STAR_RESIDUAL_ORTHOGONALITY_UNDER_COHERENCE.md" in text
    assert "STAR_STELLAR_COERCIVITY_SPLIT.md" in text
    assert "STAR_ENTROPY_ENERGY_DOMINATION.md" in text
    assert "STAR_COLLAPSE_REGULARITY.md" in text
    assert "STAR_PHASE_BOUNDARY_RIGIDITY.md" in text
    assert "STAR_NORMALIZATION.md" in text
    assert "STAR_DRAGON_COMPLETENESS.md" in text
    assert "STAR_MINIMAL_MISSING_PACKAGE.md" in text
    assert "R3 \\prec (R1A+R1B) \\prec R2 \\prec R6 \\prec R5 \\prec R8 \\prec R4." in text
    assert "Terminal unresolved theorem-replacement object: DraG0n Completeness." in text
