from __future__ import annotations

import argparse
from pathlib import Path

from guarded_network_execution import guarded_http_post


TRUSTED_PUBLIC_KEY = Path(__file__).with_name("aiv_pub.key")


def post_timestamp_query(
    *,
    target: str,
    query_path: str | Path,
    response_path: str | Path,
    token_path: str | Path,
    signature_path: str | Path,
    timeout: float = 5.0,
) -> None:
    """POST one RFC3161 query through the signed network-capability guard."""
    query = Path(query_path).read_bytes()
    response = guarded_http_post(
        target=target,
        body=query,
        token_path=token_path,
        signature_path=signature_path,
        public_key_path=TRUSTED_PUBLIC_KEY,
        content_type="application/timestamp-query",
        timeout=timeout,
    )

    output = Path(response_path)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_bytes(response)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="POST an RFC3161 timestamp query through the local signed-capability guard."
    )
    parser.add_argument("--target", required=True)
    parser.add_argument("--query", required=True)
    parser.add_argument("--response", required=True)
    parser.add_argument("--token", required=True)
    parser.add_argument("--signature", required=True)
    parser.add_argument("--timeout", type=float, default=5.0)
    args = parser.parse_args()

    post_timestamp_query(
        target=args.target,
        query_path=args.query,
        response_path=args.response,
        token_path=args.token,
        signature_path=args.signature,
        timeout=args.timeout,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
