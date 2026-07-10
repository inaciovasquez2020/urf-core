from pathlib import Path

text = Path(
    "hodge-rigidity/mixed_fixed_part_admissible.tex"
).read_text()

required = (
    r"\begin{conjecture}[Rational horizontal subtori]",
    r"T = \mathsf{Flip}(T)",
    "BOUNDARY: the fixed-part theorem identifies a rational mixed Hodge substructure",
    r"does not by itself identify the original real subtorus",
    r"with its rational envelope $\mathsf{Flip}(T)$.",
    "A separate admissible",
    "rigidity theorem proving this identification is required.",
)

for fragment in required:
    if fragment not in text:
        raise SystemExit(
            f"MIXED_FIXED_PART_BOUNDARY_MISSING := {fragment}"
        )

for forbidden in (
    r"\begin{corollary}[Rational horizontal subtori]",
    r"Apply Proposition (Flip preserves horizontality)",
    r"The minimal rational envelope forces $T = \mathsf{Flip}(T)$.",
):
    if forbidden in text:
        raise SystemExit(
            f"MIXED_FIXED_PART_UNSUPPORTED_CLAIM_PRESENT := {forbidden}"
        )

print("MIXED_FIXED_PART_BOUNDARY_OK")
