import subprocess
from pathlib import Path


def test_arithmetic_spectral_coercivity_firex_supply_rule_concrete_source_obligation_verifier() -> None:
    root = Path(__file__).resolve().parents[1]
    verifier = root / "tools" / "verify_arithmetic_spectral_coercivity_firex_supply_rule_concrete_source_obligation.py"

    result = subprocess.run(
        ["python3", str(verifier)],
        cwd=root,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode == 0, result.stdout + result.stderr
