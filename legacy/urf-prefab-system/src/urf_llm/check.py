import argparse
import sys
import json
import hashlib


def check_text(input_text: str) -> bool:
    """
    Prefab admissibility check.

    Returns True for ACCEPT, False for REJECT.
    Deterministic, CLR-aligned.
    """
    lowered = input_text.lower()

    # Strong homogeneity / indistinguishability claims
    has_strong_homogeneity = (
        "perfect local homogeneity" in lowered
        or "locally indistinguishable" in lowered
    )

    # Claims of persistence at all scales or forever
    has_global_extent = (
        "all radii" in lowered
        or "everywhere" in lowered
        or "forever" in lowered
    )

    # Rich cycle structure
    has_many_cycles = (
        "unbounded cycle overlap" in lowered
        or "many cycles" in lowered
        or ("unbounded" in lowered and "cycle" in lowered)
    )

    # Explicit or implicit lack of local witness / break
    has_no_witness = (
        "no local witness" in lowered
        or "without any local witness" in lowered
        or "without a local witness" in lowered
        or "even with" in lowered
    )

    if has_strong_homogeneity and has_global_extent and has_many_cycles and has_no_witness:
        return False

    return True


def make_certificate(input_text: str) -> dict:
    """
    Minimal deterministic admissibility certificate.
    Hash-bound to the frozen ruleset.
    """
    return {
        "schema": "urf-prefab-cert/1.0",
        "verdict": "ACCEPT",
        "checker": "urf-llm-check",
        "ruleset": "prefab-admissibility",
        "ruleset_hash": "7eb46ce7dd9ed2371d0c2cdb4e32afe174be2c8d1aa2f58577149bc6ee5a5c3e",
        "input_hash": hashlib.sha256(
            input_text.encode("utf-8")
        ).hexdigest(),
    }


def main() -> None:
    parser = argparse.ArgumentParser(prog="urf-llm-check")
    parser.add_argument(
        "--json",
        action="store_true",
        help="Emit legacy JSON output on ACCEPT",
    )
    parser.add_argument(
        "--emit-cert",
        action="store_true",
        help="Emit JSON certificate on ACCEPT",
    )

    args = parser.parse_args()

    input_text = sys.stdin.read().strip()

    if not input_text:
        print("REJECT")
        sys.exit(1)

    accepted = check_text(input_text)

    if accepted:
        print("ACCEPT")

        if args.emit_cert:
            print(json.dumps(make_certificate(input_text), sort_keys=True))
        elif args.json:
            print(json.dumps({"verdict": "ACCEPT"}, sort_keys=True))

        sys.exit(0)
    else:
        print("REJECT")
        sys.exit(1)


if __name__ == "__main__":
    main()

