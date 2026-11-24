from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LAW3 = ROOT / "urf_law3.lean"
DOC = ROOT / "docs/status/URF_LAW3_PRIMITIVE_OBLIGATION_LOCALIZATION_2026_05_26.md"

def main() -> None:
    law3 = LAW3.read_text()
    doc = DOC.read_text()
    import re
    from lean_obligation_scan import strip_noncode
    assert not re.search(
        r"\b(?:axiom|sorry|admit)\b", strip_noncode(law3)
    )

    required_law3 = [
        "(CMI : State",
        "(per_step_capacity :",
        "theorem urf_law3",
        "exact per_step_capacity T t ht",
    ]
    required_doc = [
        "LOAD_BEARING_OBLIGATION_LOCALIZED",
        "CMI_Nonneg_From_Definition",
        "`CMI` is an uninterpreted constant",
        "`capacity`",
        "`chain_rule`",
        "`cmi_nonneg`",
        "full URF-core load-bearing theorem closure",
        "P vs NP",
        "any Clay problem",
    ]

    missing = [s for s in required_law3 if s not in law3]
    missing += [s for s in required_doc if s not in doc]

    if missing:
        raise SystemExit("missing required localization tokens: " + ", ".join(missing))

    print("URF_LAW3_PRIMITIVE_OBLIGATION_LOCALIZATION_OK")

if __name__ == "__main__":
    main()
