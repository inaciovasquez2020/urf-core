from __future__ import annotations

import hashlib
import subprocess
import tempfile
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
VERIFIER = REPO_ROOT / "scripts" / "verify_checksums.sh"


def manifest_line(content: bytes, path: str = "payload.bin") -> str:
    return f"{hashlib.sha256(content).hexdigest()}  {path}\n"


class ChecksumVerifierTests(unittest.TestCase):
    def run_verifier(self, root: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            ["bash", str(VERIFIER), str(root)],
            check=False,
            capture_output=True,
            text=True,
        )

    def test_valid_manifest_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            payload = b"valid payload\n"
            (root / "payload.bin").write_bytes(payload)
            (root / "CHECKSUMS.txt").write_text(manifest_line(payload), encoding="utf-8")
            result = self.run_verifier(root)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("1 entries verified", result.stdout)

    def test_missing_file_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "CHECKSUMS.txt").write_text(manifest_line(b"absent"), encoding="utf-8")
            result = self.run_verifier(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("missing file", result.stderr)

    def test_digest_mismatch_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "payload.bin").write_bytes(b"changed")
            (root / "CHECKSUMS.txt").write_text(manifest_line(b"original"), encoding="utf-8")
            result = self.run_verifier(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("SHA-256 mismatch", result.stderr)

    def test_malformed_line_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "CHECKSUMS.txt").write_text("not a checksum line\n", encoding="utf-8")
            result = self.run_verifier(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("malformed manifest line", result.stderr)

    def test_duplicate_path_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            payload = b"valid payload\n"
            (root / "payload.bin").write_bytes(payload)
            entry = manifest_line(payload)
            (root / "CHECKSUMS.txt").write_text(entry + entry, encoding="utf-8")
            result = self.run_verifier(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("duplicate path", result.stderr)

    def test_parent_path_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            entry = hashlib.sha256(b"outside").hexdigest() + "  ../outside.bin\n"
            (root / "CHECKSUMS.txt").write_text(entry, encoding="utf-8")
            result = self.run_verifier(root)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("unsafe path", result.stderr)


if __name__ == "__main__":
    unittest.main()
