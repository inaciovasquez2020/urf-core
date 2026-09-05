from __future__ import annotations

from datetime import datetime
from pathlib import Path
from typing import Optional
from urllib.request import HTTPRedirectHandler, Request, build_opener

from signed_network_capability import verify_signed_network_capability


class NetworkCapabilityDenied(PermissionError):
    """Raised before external I/O when signed network authorization is absent."""


class NetworkRedirectDenied(NetworkCapabilityDenied):
    """Raised when an authorized request attempts to redirect to another target."""


class _RejectRedirectHandler(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise NetworkRedirectDenied(
            f"external network redirect denied from {req.full_url} to {newurl}"
        )


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
) -> bytes:
    """Perform one non-redirecting HTTP POST after target-bound authorization.

    Authorization is verified before request construction or opener creation.
    The transport rejects redirects, so a capability for one target cannot be
    reused implicitly for a second network hop selected by an HTTP response.
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
    opener = build_opener(_RejectRedirectHandler())
    with opener.open(request, timeout=timeout) as response:
        return response.read()
