import json
import sys
from pathlib import Path

REGISTRY = Path("artifacts/status/claim_registry.json")

ALLOWED = {
    "PROVED",
    "RESTRICTED",
    "CONDITIONAL",
    "INTERFACE_ONLY",
    "OPEN",
    "NOT_CLAIMED",
}

CLOSURE_WORDS = [
    "solves",
    "proves unrestricted",
    "completes",
    "establishes unrestricted",
    "resolves",
    "breakthrough",
    "final proof",
    "P vs NP",
    "Clay problem",
    "Chronos-RR closure",
    "H4.1/FGL closure",
    "Lambda-CDM failure",
    "empirical validation",
]

data = json.loads(REGISTRY.read_text())
errors = []

for claim in data.get("claims", []):
    cid = claim.get("id", "<missing-id>")
    status = claim.get("status")
    text = claim.get("public_claim", "")
    boundary = claim.get("boundary", [])
    evidence = claim.get("evidence", [])
    forbidden = claim.get("forbidden_promotions", [])

    if status not in ALLOWED:
        errors.append(f"{cid}: invalid status {status}")

    if status != "PROVED" and not boundary:
        errors.append(f"{cid}: non-PROVED claim lacks boundary")

    lowered = text.lower()

    for word in CLOSURE_WORDS:
        if word.lower() in lowered and status != "PROVED":
            errors.append(f"{cid}: closure wording used without PROVED status: {word}")

    for word in forbidden:
        if word.lower() in lowered:
            errors.append(f"{cid}: forbidden promotion appears in public claim: {word}")

    if status == "PROVED" and not evidence:
        errors.append(f"{cid}: PROVED claim lacks evidence list")

if errors:
    print("ZERO_OVERCLAIM_VERIFIER_FAILED")
    for e in errors:
        print(e)
    sys.exit(1)

print("ZERO_OVERCLAIM_VERIFIER_OK")
