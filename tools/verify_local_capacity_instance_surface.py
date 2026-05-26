from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "local_capacity_instance_surface.lean"
DOC = ROOT / "docs/status/LOCAL_CAPACITY_INSTANCE_SURFACE_2026_05_26.md"

def main() -> None:
    lean = LEAN.read_text()
    doc = DOC.read_text()

    required_lean = [
        "structure LocalCapacityInstanceData",
        "localMI : ℝ",
        "local_capacity_bound : localMI ≤ 1",
        "theorem local_capacity_instance_surface",
        "exact K.local_capacity_bound",
    ]

    required_doc = [
        "INSTANCE_LEVEL_CAPACITY_SURFACE_ONLY",
        "`local_chain_rule_instance_surface`",
        "`LocalCapacityInstanceData`",
        "`local_capacity_instance_surface`",
        "does not replace the global `capacity` axiom",
        "does not replace the global `chain_rule` axiom",
        "does not replace the global `cmi_nonneg` axiom",
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

    print("LOCAL_CAPACITY_INSTANCE_SURFACE_OK")

if __name__ == "__main__":
    main()
