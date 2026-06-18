import subprocess


def test_gravity_qft_classical_limit_source_map_verifier():
    result = subprocess.run(
        ["python3", "tools/verify_gravity_qft_classical_limit_source_map.py"],
        check=True,
        text=True,
        capture_output=True,
    )
    assert "GRAVITY_QFT_CLASSICAL_LIMIT_SOURCE_MAP_OK" in result.stdout
