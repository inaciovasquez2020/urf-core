import pathlib, re, sys
s = pathlib.Path(sys.argv[1]).read_text()
if re.search(r"\b(error|warning):", s) or "sorryAx" in s:
    raise SystemExit("FAIL: diagnostic or proof hole")
names = [
    "cyclePartition_shortBall_eq_component",
    "cyclePartition_shortBall_rootedIso",
    "canonicalShortCycleClass_eq_iff",
    "canonicalShortCycleClass_ne_centeredPathClass",
    "cyclePartition_mixedObservation_eq_lengthMap",
    "cyclePartition_mixedObservation_weightSum",
    "cyclePartition_mixedObservation_recoverStatistics",
    "cyclePartition_mixedCount_bounds",
    "cyclePartition_mixed_radius_minimax_value",
]
allowed = {"propext", "Classical.choice", "Quot.sound"}
for name in names:
    target = "URF.EntropyBridge." + name
    m = re.findall(r"'" + re.escape(target) + r"' depends on axioms:\s*\[([^\]]*)\]", s)
    if len(m) != 1:
        raise SystemExit("FAIL: expected exactly one axiom report for " + target)
    used = {v.strip() for v in m[0].split(",") if v.strip()}
    if not used <= allowed:
        raise SystemExit(f"FAIL: unexpected axioms for {target}: {used-allowed}")
    print("TARGET := " + target)
    print("AXIOMS := " + ", ".join(sorted(used)))
print("AXIOM_AUDIT := PASS_9_OF_9")
print("LEAN_COMPILATION := PASS")
print("GENERALIZED_MINIMAX := LEAN_VERIFIED")
