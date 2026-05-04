from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]

TARGETS = [
    ROOT / "lean" / "URF" / "TransferOperator.lean",
    ROOT / "docs" / "foundations" / "TRANSFER_OPERATOR.md",
]

REQUIRED = [
    "status_nonincrease",
    "transfer_no_status_promotion",
    "CertifiedFrontier.transport",
    "transfer_cannot_promote_frontier_open_to_solved",
    "transfer_target_solved_requires_source_rank_at_least_solved",
    "CERTIFICATE_TRANSPORT_ONLY",
    "THEOREM_CLOSURE = false",
    "STATUS_PROMOTION_ALLOWED = false",
    "BOUNDARY_PRESERVATION_REQUIRED = true",
]

FORBIDDEN = [
    r"THEOREM_CLOSURE\s*=\s*true",
    r"STATUS_PROMOTION_ALLOWED\s*=\s*true",
    r"StatusPromotes.*:=\s*True",
]

text = "\n".join(path.read_text() for path in TARGETS if path.exists())

missing = [needle for needle in REQUIRED if needle not in text]
if missing:
    print("Missing required TransferOperator guard(s):")
    for item in missing:
        print(f"- {item}")
    raise SystemExit(1)

violations = [
    pattern for pattern in FORBIDDEN
    if re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL)
]

if violations:
    print("Forbidden TransferOperator promotion pattern(s):")
    for item in violations:
        print(f"- {item}")
    raise SystemExit(1)

print("TransferOperator guard verified: CERTIFICATE_TRANSPORT_ONLY")
raise SystemExit(0)
