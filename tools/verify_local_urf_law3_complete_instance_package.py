from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "local_urf_law3_complete_instance_package.lean"
DOC = ROOT / "docs/status/LOCAL_URF_LAW3_COMPLETE_INSTANCE_PACKAGE_2026_05_26.md"

def main() -> None:
    lean = LEAN.read_text()
    doc = DOC.read_text()

    required_lean = [
        "structure LocalURFLaw3CompleteInstancePackage",
        "localCMI_nonneg",
        "local_chain_rule",
        "local_capacity",
        "theorem local_urf_law3_complete_instance_package",
        "Finset.single_le_sum",
        "le_trans hterm_le_sum hsum_le_one",
    ]

    required_doc = [
        "COMPLETE_INSTANCE_PACKAGE_ONLY",
        "`localCMI_to_urf_law3_instance`",
        "`local_chain_rule_instance_surface`",
        "`local_capacity_instance_surface`",
        "`LocalURFLaw3CompleteInstancePackage`",
        "`local_urf_law3_complete_instance_package`",
        "does not replace the global `cmi_nonneg` axiom",
        "does not replace the global `chain_rule` axiom",
        "does not replace the global `capacity` axiom",
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

    print("LOCAL_URF_LAW3_COMPLETE_INSTANCE_PACKAGE_OK")

if __name__ == "__main__":
    main()
