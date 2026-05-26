from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "finite_cmi_to_local_cmi_nonneg_interface.lean"
DOC = ROOT / "docs/status/FINITE_CMI_TO_LOCAL_CMI_NONNEG_INTERFACE_2026_05_26.md"

def main() -> None:
    lean = LEAN.read_text()
    doc = DOC.read_text()

    required_lean = [
        "structure LocalFiniteCMIData",
        "def localCMI",
        "theorem localCMI_nonneg_from_finite_interface",
        "K.p_nonneg ω a b",
    ]

    required_doc = [
        "LOCAL_INTERFACE_BRIDGE_ONLY",
        "`finiteCMI_nonneg_from_KL`",
        "`localCMI`",
        "`localCMI_nonneg_from_finite_interface`",
        "does not replace the global `cmi_nonneg` axiom",
        "does not prove the global `chain_rule`",
        "does not prove the global `capacity` bound",
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

    print("FINITE_CMI_TO_LOCAL_CMI_NONNEG_INTERFACE_OK")

if __name__ == "__main__":
    main()
