import contextlib
import io
import json
import sys
import tempfile
import unittest
from argparse import Namespace
from pathlib import Path

SOURCE_ROOT = Path(__file__).resolve().parents[1] / "src"
sys.path.insert(0, str(SOURCE_ROOT))

from urf_cli.__main__ import cmd_verify


VALID_CERTIFICATE = {
    "schema": "URF-SG/v1.0",
    "cert_id": "test-certificate",
    "issued_utc": "2026-10-20T12:00:00Z",
    "subject": {
        "hilbert_space": "test space",
        "operator": "test operator",
        "per": "test parameter",
    },
    "statement": {"lambda1_lower_bound": 0.1},
    "evidence": {"method": "analytic", "artifacts": []},
    "hashes": {"manifest_sha256": "a" * 64},
}


class VerifyCommandTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp_dir.cleanup)
        self.root = Path(self.temp_dir.name)
        self.cert_path = self.root / "certificate.json"

    def run_verify(self, certificate_text=None, cert_path=None):
        if certificate_text is not None:
            self.cert_path.write_text(certificate_text, encoding="utf-8")
        elif not self.cert_path.exists():
            self.cert_path.write_text(
                json.dumps(VALID_CERTIFICATE), encoding="utf-8"
            )

        stdout = io.StringIO()
        stderr = io.StringIO()
        args = Namespace(cert=str(cert_path or self.cert_path), schema=None)
        with contextlib.redirect_stdout(stdout), contextlib.redirect_stderr(stderr):
            result = cmd_verify(args)
        return result, stdout.getvalue(), stderr.getvalue()

    def test_valid_certificate_passes(self):
        result, stdout, stderr = self.run_verify()
        self.assertEqual(result, 0)
        self.assertEqual(stdout.strip(), "VALID")
        self.assertEqual(stderr, "")

    def test_schema_violation_has_concise_error(self):
        invalid = dict(VALID_CERTIFICATE, schema="WRONG")
        result, stdout, stderr = self.run_verify(json.dumps(invalid))
        self.assertEqual(result, 1)
        self.assertEqual(stdout, "")
        self.assertIn("certificate validation failed", stderr)
        self.assertNotIn("Traceback", stderr)

    def test_invalid_json_has_concise_error(self):
        result, stdout, stderr = self.run_verify("{")
        self.assertEqual(result, 2)
        self.assertEqual(stdout, "")
        self.assertIn("invalid JSON", stderr)
        self.assertNotIn("Traceback", stderr)

    def test_missing_file_has_concise_error(self):
        missing = self.root / "missing.json"
        result, stdout, stderr = self.run_verify(cert_path=missing)
        self.assertEqual(result, 2)
        self.assertEqual(stdout, "")
        self.assertIn("cannot read certificate", stderr)
        self.assertNotIn("Traceback", stderr)

    def test_invalid_date_time_is_rejected(self):
        invalid = dict(VALID_CERTIFICATE, issued_utc="yesterday")
        result, stdout, stderr = self.run_verify(json.dumps(invalid))
        self.assertEqual(result, 1)
        self.assertEqual(stdout, "")
        self.assertIn("issued_utc", stderr)
        self.assertNotIn("Traceback", stderr)


if __name__ == "__main__":
    unittest.main()
