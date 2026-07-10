from pathlib import Path

mixed = Path("lemmas/tori-flip/flip_mixed_hodge.tex").read_text()
horizontal = Path("lemmas/tori-flip/flip_horizontal.tex").read_text()

required_mixed = (
    r"\begin{conjecture}[Mixed Hodge Horizontal Rigidity]",
    r"T = \mathsf{Flip}(T)",
    "BOUNDARY: horizontality of $\\mathsf{Flip}(T)$ does not by itself prove",
    "A separate rigidity theorem identifying the real",
)

for fragment in required_mixed:
    if fragment not in mixed:
        raise SystemExit(
            f"TORI_FLIP_BOUNDARY_MISSING := {fragment}"
        )

for forbidden in (
    r"\begin{theorem}[Mixed Hodge Horizontal Rigidity]",
    r"\begin{proof}",
    "Therefore $T$ must already equal its rational closure.",
):
    if forbidden in mixed:
        raise SystemExit(
            f"TORI_FLIP_UNSUPPORTED_CLAIM_PRESENT := {forbidden}"
        )

if r"\begin{lemma}[Flip preserves horizontality]" not in horizontal:
    raise SystemExit(
        "TORI_FLIP_HORIZONTAL_LEMMA_MISSING"
    )

print("TORI_FLIP_BOUNDARY_OK")
