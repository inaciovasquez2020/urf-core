import subprocess

def test_provenance_codec_interface_verifier_passes():
    result = subprocess.run(
        ["python3", "tools/verify_provenance_codec_interface.py"],
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert "PROVENANCE_CODEC_INTERFACE_OK" in result.stdout
