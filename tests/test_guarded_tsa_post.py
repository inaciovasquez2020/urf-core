from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NETWORK_CAPABILITY = ROOT / "scripts" / "network_capability"
sys.path.insert(0, str(NETWORK_CAPABILITY))

import guarded_tsa_post as gtp


def test_guarded_tsa_post_preserves_target_and_rfc3161_body(monkeypatch, tmp_path: Path) -> None:
    query = tmp_path / "request.tsq"
    response = tmp_path / "nested" / "response.tsr"
    query.write_bytes(b"rfc3161-query")

    captured = {}

    def fake_guarded_http_post(**kwargs):
        captured.update(kwargs)
        return b"rfc3161-response"

    monkeypatch.setattr(gtp, "guarded_http_post", fake_guarded_http_post)

    gtp.post_timestamp_query(
        target="http://timestamp.digicert.com",
        query_path=query,
        response_path=response,
        token_path=tmp_path / "capability.json",
        signature_path=tmp_path / "capability.json.minisig",
        public_key_path=tmp_path / "capability.pub",
        timeout=7.0,
    )

    assert captured["target"] == "http://timestamp.digicert.com"
    assert captured["body"] == b"rfc3161-query"
    assert captured["content_type"] == "application/timestamp-query"
    assert captured["timeout"] == 7.0
    assert response.read_bytes() == b"rfc3161-response"
