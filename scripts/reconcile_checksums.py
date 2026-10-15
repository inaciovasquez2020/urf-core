#!/usr/bin/env python3
"""Reconcile CHECKSUMS.txt against the current tree without expanding its scope.

Existing manifest entries are retained and rehashed when their files exist.
Entries whose paths no longer exist in the checkout are removed. Unlisted files
are never added automatically.
"""
from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path

DIGEST_RE = re.compile(r"^[0-9a-fA-F]{64}$")


def reconcile(root: Path, manifest: Path, write: bool) -> int:
    root = root.resolve()
    manifest_path = (root / manifest).resolve()
    if not manifest_path.is_relative_to(root):
        raise SystemExit("manifest path escapes repository root")

    raw = manifest_path.read_text(encoding="utf-8")
    lines = raw.splitlines()
    seen: set[str] = set()
    output: list[str] = []
    removed = 0
    changed = 0

    for number, line in enumerate(lines, start=1):
        if not line:
            raise SystemExit(f"{manifest}:{number}: blank line is not allowed")
        parts = line.split("  ", 1)
        if len(parts) != 2 or not DIGEST_RE.fullmatch(parts[0]):
            raise SystemExit(f"{manifest}:{number}: malformed checksum entry")
        expected, rel = parts
        path = Path(rel)
        if path.is_absolute() or ".." in path.parts or not rel:
            raise SystemExit(f"{manifest}:{number}: unsafe path {rel!r}")
        if rel in seen:
            raise SystemExit(f"{manifest}:{number}: duplicate path {rel!r}")
        seen.add(rel)

        candidate = (root / path).resolve()
        if not candidate.is_relative_to(root):
            raise SystemExit(f"{manifest}:{number}: path escapes repository: {rel}")
        if not candidate.is_file():
            print(f"REMOVE missing: {rel}")
            removed += 1
            continue

        actual = hashlib.sha256(candidate.read_bytes()).hexdigest()
        if actual != expected.lower():
            print(f"UPDATE digest: {rel}")
            changed += 1
        output.append(f"{actual}  {rel}")

    if not output:
        raise SystemExit("refusing to write an empty checksum manifest")
    new = "\n".join(output) + "\n"
    if write:
        manifest_path.write_text(new, encoding="utf-8")
    elif new != raw:
        print("Manifest differs; rerun with --write to apply changes.")
        return 1

    print(
        f"SUMMARY entries_in={len(lines)} entries_out={len(output)} "
        f"digest_updates={changed} missing_removed={removed} write={write}"
    )
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", default=".")
    parser.add_argument("--manifest", default="CHECKSUMS.txt")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    return reconcile(Path(args.root), Path(args.manifest), args.write)


if __name__ == "__main__":
    sys.exit(main())
