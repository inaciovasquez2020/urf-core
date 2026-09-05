from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Callable, Optional
from urllib.request import Request, urlopen

from signed_network_capability import verify_signed_network_capability


class NetworkCapabilityDenied(PermissionError):
    """Raised before external I/O when signed network authorization is absent."""


def guarded_http_post(
    *,
    target: str,
    body: bytes,
    token_path: str | Path,
    signature_path: str | Path,
    public_key_path: str | Path,
    content_type: str = "application/octet-stream",
    timeout: float = 5.0,
    now: Optional[datetime] = None,
    opener: Optional[Callable[..., object]] = None,
) -> bytes:
    """Perform one HTTP POST only after a valid target-bound capability verifies.

    The authorization decision is made before constructing or opening the
    request. Missing, malformed, expired, mismatched, or unverifiable
    capabilities therefore deny the network action before external I/O.
    """
    authorized = verify_signed_network_capability(
        token_path=token_path,
        signature_path=signature_path,
        public_key_path=public_key_path,
        expected_target=target,
        now=now,
    )
    if not authorized:
        raise NetworkCapabilityDenied(f"external network capability denied for {target}")

    request = Request(
        target,
        data=body,
        headers={"Content-Type": content_type},
        method="POST",
    )
    open_request = opener or urlopen
    with open_request(request, timeout=timeout) as response:
        return response.read()
