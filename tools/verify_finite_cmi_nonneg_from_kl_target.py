from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "finite_cmi_nonneg_from_kl.lean"
DOC = ROOT / "docs/status/FINITE_CMI_NONNEG_FROM_KL_TARGET_2026_05_26.md"

def main() -> None:
    lean = LEAN.read_text()
    doc = DOC.read_text()

    required_lean = [
        "structure FiniteKernel",
        "def finiteCMI",
        "theorem finiteCMI_nonneg_from_KL",
        "K.p_nonneg",
    ]

    required_doc = [
        "FINITE_OBJECT_LAYER_ONLY",
        "`CMI_Nonneg_From_Definition`",
        "does not replace the global `cmi_nonneg` axiom",
        "does not prove the global chain rule",
        "does not prove the global capacity bound",
        "full URF-core load-bearing theorem closure",
        "unrestricted Chronos-RR",
        "unrestricted H4.1/FGL",
        "P vs NP",
        "any Clay problem",
    ]

    forbidden = [
        "unrestricted Chronos-RR closure",
        "unrestricted H4.1/FGL closure",
        "P vs NP closure",
        "Clay closure",
    ]

    missing = [s for s in required_lean if s not in lean]
    missing += [s for s in required_doc if s not in doc]
    bad = [s for s in forbidden if s in doc]

    if missing:
        raise SystemExit("missing required tokens: " + ", ".join(missing))
    if bad:
        raise SystemExit("forbidden overclaim tokens: " + ", ".join(bad))

    print("FINITE_CMI_NONNEG_FROM_KL_TARGET_OK")

if __name__ == "__main__":
    main()
