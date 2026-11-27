import pathlib, re, sys
p = pathlib.Path(sys.argv[1])
s = p.read_text()
if re.search(r"\b(error|warning):", s) or "sorryAx" in s:
    raise SystemExit("FAIL: diagnostic or proof hole")
target = "URF.EntropyBridge.cyclePartition_shortBall_eq_component"
m = re.findall(r"'" + re.escape(target) + r"' depends on axioms:\s*\[([^\]]*)\]", s)
if len(m) != 1:
    raise SystemExit("FAIL: expected exactly one target axiom report")
used = {v.strip() for v in m[0].split(",") if v.strip()}
allowed = {"propext", "Classical.choice", "Quot.sound"}
if not used <= allowed:
    raise SystemExit(f"FAIL: unexpected axioms {used-allowed}")
print("TARGET := " + target)
print("AXIOMS := " + ", ".join(sorted(used)))
print("AXIOM_AUDIT := PASS")
print("LEAN_COMPILATION := PASS")
print("GENERALIZED_MINIMAX := OPEN")
