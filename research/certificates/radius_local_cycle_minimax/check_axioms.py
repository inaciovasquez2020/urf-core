import re
import sys
from pathlib import Path

audit = Path(sys.argv[1]).read_text(encoding="utf-8")
log = Path(sys.argv[2]).read_text(encoding="utf-8")
names = re.findall(r"^#print axioms (\S+)$", audit, re.MULTILINE)
if len(names) != 37 or len(set(names)) != 37 or "cyclePartition_radius_minimax_value" not in names:
    raise SystemExit("Expected 37 distinct audit targets including the final theorem")

allowed = {"propext", "Classical.choice", "Quot.sound"}
for name in names:
    full_name = f"URF.EntropyBridge.{name}"
    pattern = (
        rf"^'{re.escape(full_name)}' "
        r"(?:does not depend on any axioms|depends on axioms:\s*\[([^\]]*)\])"
    )
    reports = re.findall(pattern, log, re.MULTILINE)
    if len(reports) != 1:
        raise SystemExit(f"Expected one axiom report for {full_name}")
    used = {entry.strip() for entry in reports[0].split(",") if entry.strip()}
    if not used <= allowed:
        raise SystemExit(f"Disallowed axioms for {full_name}: {sorted(used - allowed)}")
    print(f"{full_name}: {', '.join(sorted(used)) or '(none)'}")
print("PASS: 37 declarations imported through URF")
