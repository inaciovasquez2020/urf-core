from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
VERIFY = ROOT / "verify.py"
INST = ROOT / "instances"
CERT = ROOT / "certificates"


def test_all_certificates_verify():
    for graph_path in sorted(INST.glob("*.json")):
        cert_path = CERT / f"{graph_path.stem}.certificate.json"
        proc = subprocess.run(
            [sys.executable, str(VERIFY), str(graph_path), str(cert_path)],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        assert proc.returncode == 0, proc.stderr
