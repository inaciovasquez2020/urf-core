import json
import subprocess
from pathlib import Path


POLICY_PATH = Path("security/policy/NETWORK_CAPABILITY_ISSUER_BOUNDARY.json")

EXPECTED_POLICY = {
    "schema": "urf.network-capability-issuer-boundary.v1",
    "status": "RUNTIME_VERIFY_ONLY_EXTERNAL_ISSUER_BLOCKED_BY_SIGNATURE_FORMAT_MISMATCH",
    "runtime_surface": "scripts/network_capability",
    "allowed_runtime_files": [
        "aiv_pub.key",
        "guarded_network_execution.py",
        "guarded_tsa_post.py",
        "signed_network_capability.py",
    ],
    "runtime_signature_format": "minisign-detached-v1",
    "trusted_public_key": "scripts/network_capability/aiv_pub.key",
    "runtime_signing_permitted": False,
    "runtime_private_key_input_permitted": False,
    "caller_selectable_trust_root_permitted": False,
    "external_issuer_deployed": False,
    "external_identity_candidate": {
        "mechanism": "github-actions-keyless-oidc",
        "workflow": ".github/workflows/urf-sg-verifier-container.yml",
        "signature_format": "sigstore-bundle-v1",
        "format_compatible_with_runtime": False,
        "capability_artifact_emitted": False,
        "required_identity_constraints_for_future_sigstore_verifier": [
            "oidc_issuer",
            "workflow_identity",
            "workflow_repository",
            "workflow_sha",
        ],
        "required_evidence": [
            "id-token: write",
            "actions/attest-build-provenance@v2",
        ],
    },
    "promotion_gate": {
        "blocked": True,
        "reasons": [
            "runtime verifier accepts Minisign detached signatures while candidate emits Sigstore attestations",
            "candidate workflow does not emit a signed network-capability token",
        ],
        "acceptable_resolution": [
            "add and verify a Sigstore capability verifier with pinned GitHub OIDC workflow identity constraints",
            "or deploy an external issuer that produces Minisign detached signatures from a key outside runtime authority",
        ],
    },
    "certified_property": (
        "checked TSA runtime surface remains verify-only and the existing GitHub "
        "OIDC/Sigstore workflow is mechanically blocked from issuer promotion until "
        "its signature format and capability artifact are compatible with the runtime verifier"
    ),
}


def _policy() -> dict:
    return json.loads(POLICY_PATH.read_text())


def test_issuer_boundary_contract_is_exact() -> None:
    assert _policy() == EXPECTED_POLICY


def test_runtime_surface_contains_only_allowlisted_tracked_files() -> None:
    policy = _policy()
    surface = policy["runtime_surface"]
    tracked = subprocess.check_output(
        ["git", "ls-files", surface], text=True
    ).splitlines()
    expected = sorted(f"{surface}/{name}" for name in policy["allowed_runtime_files"])
    assert sorted(tracked) == expected


def test_runtime_surface_has_no_signing_command_or_private_key_input() -> None:
    policy = _policy()
    forbidden_exact = (
        "NETWORK_CAPABILITY_PRIVATE_KEY",
        "MINISIGN_PRIVATE_KEY",
        "--private-key",
        "minisign encrypted secret key",
        '"minisign", "-S"',
        "cosign sign",
    )
    for name in policy["allowed_runtime_files"]:
        text = Path(policy["runtime_surface"], name).read_text()
        for marker in forbidden_exact:
            assert marker not in text

    public_key = Path(policy["trusted_public_key"]).read_text()
    assert "minisign public key" in public_key.splitlines()[0].lower()
    assert "secret key" not in public_key.lower()


def test_tsa_runtime_accepts_only_external_token_and_signature_inputs() -> None:
    tsa_script = Path("scripts/tsa-stamp.sh").read_text()
    guarded_tsa = Path("scripts/network_capability/guarded_tsa_post.py").read_text()

    assert "NETWORK_CAPABILITY_TOKEN" in tsa_script
    assert "NETWORK_CAPABILITY_SIGNATURE" in tsa_script
    assert "NETWORK_CAPABILITY_PRIVATE_KEY" not in tsa_script
    assert "NETWORK_CAPABILITY_PUBLIC_KEY" not in tsa_script
    assert 'parser.add_argument("--private-key"' not in guarded_tsa
    assert 'parser.add_argument("--public-key"' not in guarded_tsa


def test_runtime_signature_format_is_minisign_detached() -> None:
    policy = _policy()
    verifier = Path(
        policy["runtime_surface"], "signed_network_capability.py"
    ).read_text()
    assert policy["runtime_signature_format"] == "minisign-detached-v1"
    assert '"minisign"' in verifier
    assert '"-Vm"' in verifier


def test_external_identity_candidate_is_explicitly_incompatible_and_unpromoted() -> None:
    policy = _policy()
    candidate = policy["external_identity_candidate"]
    workflow = Path(candidate["workflow"]).read_text()

    assert policy["external_issuer_deployed"] is False
    assert candidate["signature_format"] == "sigstore-bundle-v1"
    assert candidate["format_compatible_with_runtime"] is False
    assert candidate["capability_artifact_emitted"] is False
    assert policy["runtime_signature_format"] != candidate["signature_format"]
    assert policy["promotion_gate"]["blocked"] is True

    for evidence in candidate["required_evidence"]:
        assert evidence in workflow


def test_future_sigstore_route_requires_pinned_github_identity_claims() -> None:
    candidate = _policy()["external_identity_candidate"]
    assert candidate["required_identity_constraints_for_future_sigstore_verifier"] == [
        "oidc_issuer",
        "workflow_identity",
        "workflow_repository",
        "workflow_sha",
    ]
