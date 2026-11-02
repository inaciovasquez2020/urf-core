import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
REGISTRY = ROOT / "artifacts/status/claim_registry.json"

ALLOWED = {
    "PROVED",
    "RESTRICTED",
    "CONDITIONAL",
    "INTERFACE_ONLY",
    "OPEN",
    "NOT_CLAIMED",
}

EVIDENCE_CLASSES = {
    "formal_proof",
    "independent_reproduction",
    "build_test",
    "artifact_integrity",
    "manual_review",
    "literature_review",
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


def safe_repo_file(raw_path, label, errors, claim_id):
    if not isinstance(raw_path, str) or not raw_path.strip():
        errors.append(f"{claim_id}: {label} path is missing")
        return None
    relative = Path(raw_path)
    if relative.is_absolute() or ".." in relative.parts:
        errors.append(f"{claim_id}: {label} path must be repository-relative and cannot traverse parents")
        return None
    path = (ROOT / relative).resolve()
    try:
        path.relative_to(ROOT.resolve())
    except ValueError:
        errors.append(f"{claim_id}: {label} path escapes repository root")
        return None
    if not path.is_file():
        errors.append(f"{claim_id}: {label} file does not exist: {raw_path}")
        return None
    return path


def is_commit_sha(value):
    return isinstance(value, str) and re.fullmatch(r"[0-9a-f]{40}", value) is not None


def validate_proof_receipt(claim, errors):
    cid = claim.get("id", "<missing-id>")
    verification = claim.get("verification")
    if not isinstance(verification, dict):
        errors.append(f"{cid}: PROVED claim lacks proof receipt")
        return
    receipt_path = safe_repo_file(verification.get("receipt"), "proof receipt", errors, cid)
    source_revision = claim.get("source_revision")
    if not is_commit_sha(source_revision):
        errors.append(f"{cid}: PROVED claim source_revision is not a full immutable Git commit SHA")
    if verification.get("source_revision") != source_revision:
        errors.append(f"{cid}: PROVED claim has stale source revision")
    evidence_class = verification.get("evidence_class")
    if not isinstance(evidence_class, str) or evidence_class not in EVIDENCE_CLASSES:
        errors.append(f"{cid}: proof receipt has invalid evidence_class: {evidence_class}")
    elif evidence_class != "formal_proof":
        errors.append(f"{cid}: PROVED claim requires formal_proof evidence_class")

    artifacts = verification.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        errors.append(f"{cid}: proof receipt lacks artifact hash records")
        artifacts = []

    normalized_artifacts = []
    for index, artifact in enumerate(artifacts):
        if not isinstance(artifact, dict):
            errors.append(f"{cid}: artifact record {index} is not an object")
            continue
        artifact_path_value = artifact.get("path")
        expected_hash = artifact.get("sha256")
        if not isinstance(expected_hash, str) or re.fullmatch(r"[0-9a-f]{64}", expected_hash) is None:
            errors.append(f"{cid}: artifact record {index} has invalid SHA-256")
            continue
        artifact_path = safe_repo_file(artifact_path_value, f"artifact {index}", errors, cid)
        if artifact_path is None:
            continue
        actual_hash = hashlib.sha256(artifact_path.read_bytes()).hexdigest()
        if actual_hash != expected_hash:
            errors.append(f"{cid}: artifact hash mismatch for {artifact_path_value}")
        normalized_artifacts.append({"path": artifact_path_value, "sha256": expected_hash})

    if receipt_path is None:
        return
    try:
        receipt_data = json.loads(receipt_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        errors.append(f"{cid}: proof receipt is not readable JSON: {exc}")
        return
    if not isinstance(receipt_data, dict):
        errors.append(f"{cid}: proof receipt root must be a JSON object")
        return
    if receipt_data.get("source_revision") != source_revision:
        errors.append(f"{cid}: receipt content source_revision does not match claim")
    if receipt_data.get("evidence_class") != evidence_class:
        errors.append(f"{cid}: receipt content evidence_class does not match verification record")
    if receipt_data.get("artifacts") != normalized_artifacts:
        errors.append(f"{cid}: receipt content artifact records do not match verified records")


if not REGISTRY.is_file():
    print(f"ZERO_OVERCLAIM_VERIFIER_FAILED\nclaim registry does not exist: {REGISTRY}")
    sys.exit(1)

try:
    data = json.loads(REGISTRY.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as exc:
    print(f"ZERO_OVERCLAIM_VERIFIER_FAILED\nclaim registry is not readable JSON: {exc}")
    sys.exit(1)

errors = []

for claim in data.get("claims", []):
    cid = claim.get("id", "<missing-id>")
    status = claim.get("status")
    text = claim.get("public_claim", "")
    boundary = claim.get("boundary", [])
    evidence = claim.get("evidence", [])
    forbidden = claim.get("forbidden_promotions", [])
    unresolved_obligations = claim.get("unresolved_obligations", [])

    if not isinstance(status, str) or status not in ALLOWED:
        errors.append(f"{cid}: invalid status {status}")

    if status != "PROVED" and not boundary:
        errors.append(f"{cid}: non-PROVED claim lacks boundary")

    if status == "PROVED" and unresolved_obligations:
        errors.append(f"{cid}: PROVED claim has unresolved obligations")

    if not isinstance(text, str):
        errors.append(f"{cid}: public_claim must be a string")
        text = ""
    lowered = text.lower()

    for word in CLOSURE_WORDS:
        if word.lower() in lowered and status != "PROVED":
            errors.append(f"{cid}: closure wording used without PROVED status: {word}")

    if not isinstance(forbidden, list):
        errors.append(f"{cid}: forbidden_promotions must be a list")
        forbidden = []
    for word in forbidden:
        if isinstance(word, str) and word.lower() in lowered:
            errors.append(f"{cid}: forbidden promotion appears in public claim: {word}")

    if status == "PROVED" and not evidence:
        errors.append(f"{cid}: PROVED claim lacks evidence list")

    if status == "PROVED":
        validate_proof_receipt(claim, errors)

if errors:
    print("ZERO_OVERCLAIM_VERIFIER_FAILED")
    for error in errors:
        print(error)
    sys.exit(1)

print("ZERO_OVERCLAIM_VERIFIER_OK")
