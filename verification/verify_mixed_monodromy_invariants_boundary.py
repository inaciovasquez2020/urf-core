from pathlib import Path

text = Path(
    "hodge-rigidity/mixed_fixed_part_admissible.tex"
).read_text()

required = (
    r"\begin{conjecture}[Monodromy invariants]",
    r"flat sections invariant under the Gauss--Manin connection form a sub-VMHS over $\Q$.",
    "BOUNDARY: the existence of a Deligne canonical extension with compatible",
    "does not by itself prove that invariant flat",
    "sections are closed under those filtrations or satisfy the full sub-VMHS",
    "A separate monodromy-invariant sub-VMHS theorem is required.",
    r"\begin{conjecture}[Rational horizontal subtori]",
    r"BOUNDARY: the fixed-part theorem identifies a rational mixed Hodge substructure",
)

for fragment in required:
    if fragment not in text:
        raise SystemExit(
            f"MIXED_MONODROMY_BOUNDARY_MISSING := {fragment}"
        )

for forbidden in (
    r"\begin{lemma}[Monodromy invariants]",
    r"Deligne canonical extension provides compatible weight/Hodge filtrations.",
    r"Flat sections respect these filtrations and are invariant under connection.",
):
    if forbidden in text:
        raise SystemExit(
            f"MIXED_MONODROMY_UNSUPPORTED_CLAIM_PRESENT := {forbidden}"
        )

print("MIXED_MONODROMY_BOUNDARY_OK")
