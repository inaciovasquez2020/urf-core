#!/usr/bin/env python3
"""Fail-closed verifier for the repository's SHA-256 CHECKSUMS.txt manifest."""

from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path


ENTRY = re.compile(r"^([0-9a-fA-F]{64})  (.+)$")


def verify(root: Path) -> int:
    root = root.resolve()
    manifest = root / "CHECKSUMS.txt"
    if not manifest.is_file():
        print(f"ERROR: missing manifest: {manifest}", file=sys.stderr)
        return 2

    try:
        lines = manifest.read_text(encoding="utf-8").splitlines()
    except OSError as exc:
        print(f"ERROR: cannot read manifest: {exc}", file=sys.stderr)
        return 2

    seen: set[str] = set()
    failures = 0
    entries = 0

    for line_number, line in enumerate(lines, start=1):
        if not line:
            print(f"ERROR: blank manifest line {line_number}", file=sys.stderr)
            failures += 1
            continue

        match = ENTRY.fullmatch(line)
        if match is None:
            print(f"ERROR: malformed manifest line {line_number}", file=sys.stderr)
            failures += 1
            continue

        expected, relative_name = match.groups()
        relative = Path(relative_name)
        if relative.is_absolute() or ".." in relative.parts:
            print(f"ERROR: unsafe path on line {line_number}: {relative_name}", file=sys.stderr)
            failures += 1
            continue

        if relative_name in seen:
            print(f"ERROR: duplicate path on line {line_number}: {relative_name}", file=sys.stderr)
            failures += 1
            continue
        seen.add(relative_name)
        entries += 1

        target = (root / relative).resolve()
        try:
            target.relative_to(root)
        except ValueError:
            print(f"ERROR: path escapes repository root on line {line_number}: {relative_name}", file=sys.stderr)
            failures += 1
            continue

        if not target.is_file():
            print(f"ERROR: missing file on line {line_number}: {relative_name}", file=sys.stderr)
            failures += 1
            continue

        digest = hashlib.sha256()
        try:
            with target.open("rb") as stream:
                for chunk in iter(lambda: stream.read(1024 * 1024), b""):
                    digest.update(chunk)
        except OSError as exc:
            print(f"ERROR: cannot read {relative_name}: {exc}", file=sys.stderr)
            failures += 1
            continue

        actual = digest.hexdigest()
        if actual.lower() != expected.lower():
            print(f"ERROR: SHA-256 mismatch: {relative_name}", file=sys.stderr)
            failures += 1
        else:
            print(f"OK: {relative_name}")

    if entries == 0:
        print("ERROR: manifest contains no checksum entries", file=sys.stderr)
        failures += 1

    if failures:
        print(f"CHECKSUM VERIFICATION FAILED: {failures} error(s) across {entries} entry/entries", file=sys.stderr)
        return 1

    print(f"CHECKSUM VERIFICATION PASSED: {entries} entries verified")
    return 0


if __name__ == "__main__":
    root_arg = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    raise SystemExit(verify(root_arg))
