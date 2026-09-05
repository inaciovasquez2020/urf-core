from __future__ import annotations

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
NETWORK_CAPABILITY = ROOT / "scripts" / "network_capability"
sys.path.insert(0, str(NETWORK_CAPABILITY))

import guarded_network_execution as gne


def test_denied_capability_never_builds_or_calls_network_opener(monkeypatch) -> None:
    monkeypatch.setattr(gne, "verify_signed_network_capability", lambda **_: False)

    opener_builds = []

    def forbidden_build_opener(*args, **kwargs):
        opener_builds.append((args, kwargs))
        raise AssertionError("network opener must not be built when capability is denied")

    monkeypatch.setattr(gne, "build_opener", forbidden_build_opener)

    with pytest.raises(gne.NetworkCapabilityDenied):
        gne.guarded_http_post(
            target="http://timestamp.digicert.com",
            body=b"test",
            token_path="missing-token.json",
            signature_path="missing-token.json.minisig",
            public_key_path="missing.pub",
        )

    assert opener_builds == []


def test_redirect_is_rejected_before_second_network_hop(monkeypatch) -> None:
    monkeypatch.setattr(gne, "verify_signed_network_capability", lambda **_: True)

    first_hop_calls = 0
    second_hop_calls = 0

    class RedirectingOpener:
        def __init__(self, handler):
            self.handler = handler

        def open(self, request, timeout):
            nonlocal first_hop_calls, second_hop_calls
            first_hop_calls += 1
            self.handler.redirect_request(
                request,
                None,
                302,
                "Found",
                {},
                "https://redirect-target.invalid/next",
            )
            second_hop_calls += 1
            raise AssertionError("redirect handler must deny before a second network hop")

    def fake_build_opener(*handlers):
        redirect_handlers = [
            handler for handler in handlers if isinstance(handler, gne._RejectRedirectHandler)
        ]
        assert len(redirect_handlers) == 1
        return RedirectingOpener(redirect_handlers[0])

    monkeypatch.setattr(gne, "build_opener", fake_build_opener)

    with pytest.raises(gne.NetworkRedirectDenied):
        gne.guarded_http_post(
            target="http://timestamp.digicert.com",
            body=b"test",
            token_path="token.json",
            signature_path="token.minisig",
            public_key_path="pub.key",
        )

    assert first_hop_calls == 1
    assert second_hop_calls == 0
