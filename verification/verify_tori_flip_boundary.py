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

required_horizontal = (
    r"\begin{conjecture}[Flip preserves horizontality]",
    r"\mathsf{Flip}(T)",
    r"BOUNDARY: $\mathbb{Q}$-linearity of the Gauss--Manin connection does not by",
    "preservation theorem for that envelope is required.",
)

for fragment in required_horizontal:
    if fragment not in horizontal:
        raise SystemExit(
            f"TORI_FLIP_HORIZONTAL_BOUNDARY_MISSING := {fragment}"
        )

for forbidden in (
    r"\begin{lemma}[Flip preserves horizontality]",
    r"\begin{proof}",
    r"Since $\nabla$ is $\mathbb{Q}$-linear",
):
    if forbidden in horizontal:
        raise SystemExit(
            f"TORI_FLIP_UNSUPPORTED_HORIZONTAL_CLAIM_PRESENT := {forbidden}"
        )

print("TORI_FLIP_BOUNDARY_OK")
