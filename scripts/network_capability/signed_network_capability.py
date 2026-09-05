from __future__ import annotations

import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional


CAPABILITY_KIND = "external_network"
CAPABILITY_VERSION = 1


def _parse_utc_timestamp(value: str) -> datetime:
    if value.endswith("Z"):
        value = value[:-1] + "+00:00"
    parsed = datetime.fromisoformat(value)
    if parsed.tzinfo is None:
        raise ValueError("capability expiry must be timezone-aware")
    return parsed.astimezone(timezone.utc)


def verify_signed_network_capability(
    *,
    token_path: str | Path,
    signature_path: str | Path,
    public_key_path: str | Path,
    expected_target: str,
    now: Optional[datetime] = None,
) -> bool:
    """Verify an externally signed, target-bound, unexpired network capability.

    Verification fails closed on every missing, malformed, expired, mismatched,
    or unverifiable input. The signing private key is intentionally not part of
    this interface or repository.
    """
    token = Path(token_path)
    signature = Path(signature_path)
    public_key = Path(public_key_path)

    if not token.is_file() or not signature.is_file() or not public_key.is_file():
        return False

    try:
        result = subprocess.run(
            [
                "minisign",
                "-Vm",
                str(token),
                "-x",
                str(signature),
                "-p",
                str(public_key),
            ],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=5,
        )
    except (OSError, subprocess.SubprocessError):
        return False

    if result.returncode != 0:
        return False

    try:
        payload = json.loads(token.read_text(encoding="utf-8"))
        if payload.get("version") != CAPABILITY_VERSION:
            return False
        if payload.get("capability") != CAPABILITY_KIND:
            return False
        if payload.get("target") != expected_target:
            return False

        expires_at = _parse_utc_timestamp(payload["expires_at"])
        current = now or datetime.now(timezone.utc)
        if current.tzinfo is None:
            return False
        current = current.astimezone(timezone.utc)
        if current >= expires_at:
            return False
    except (KeyError, TypeError, ValueError, json.JSONDecodeError, OSError):
        return False

    return True
