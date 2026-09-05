from __future__ import annotations

import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
NETWORK_CAPABILITY = ROOT / "scripts" / "network_capability"
sys.path.insert(0, str(NETWORK_CAPABILITY))

import guarded_network_execution as gne


def test_denied_capability_never_invokes_network_opener(monkeypatch, tmp_path: Path) -> None:
    opener_called = False

    def forbidden_opener(*args, **kwargs):
        nonlocal opener_called
        opener_called = True
        raise AssertionError("network opener must not run after denied authorization")

    monkeypatch.setattr(
        gne,
        "verify_signed_network_capability",
        lambda **kwargs: False,
    )

    with pytest.raises(gne.NetworkCapabilityDenied):
        gne.guarded_http_post(
            target="https://timestamp.digicert.com",
            body=b"test",
            token_path=tmp_path / "missing-token.json",
            signature_path=tmp_path / "missing-token.json.minisig",
            public_key_path=tmp_path / "missing.pub",
            opener=forbidden_opener,
        )

    assert opener_called is False
