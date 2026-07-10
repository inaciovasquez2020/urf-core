from pathlib import Path

text = Path(
    "hodge-rigidity/mixed_fixed_part_admissible.tex"
).read_text()

required = (
    r"\begin{conjecture}[Fixed part for admissible VMHS]",
    r"Flat sections $H^0(S, \mathbbV_\Q)$ form a rational mixed Hodge substructure.",
    "BOUNDARY: admissibility and functoriality of the Gauss--Manin connection do not",
    "by themselves prove that global flat sections inherit compatible weight and",
    "Hodge filtrations, are rational, and satisfy the mixed Hodge substructure",
    "A separate fixed-part theorem for admissible VMHS is required.",
    r"\begin{conjecture}[Monodromy invariants]",
    r"\begin{conjecture}[Rational horizontal subtori]",
)

for fragment in required:
    if fragment not in text:
        raise SystemExit(
            f"MIXED_FIXED_PART_THEOREM_BOUNDARY_MISSING := {fragment}"
        )

for forbidden in (
    r"\begin{theorem}[Fixed part for admissible VMHS]",
    r"Admissibility ensures well-behaved filtrations.",
    r"Functoriality under Gauss--Manin connection ensures rationality.",
):
    if forbidden in text:
        raise SystemExit(
            f"MIXED_FIXED_PART_THEOREM_UNSUPPORTED_CLAIM_PRESENT := {forbidden}"
        )

print("MIXED_FIXED_PART_THEOREM_BOUNDARY_OK")
