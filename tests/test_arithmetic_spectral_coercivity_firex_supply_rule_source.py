import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def test_arithmetic_spectral_coercivity_firex_supply_rule_source_boundary():
    result = subprocess.run(
        [sys.executable, "tools/verify_arithmetic_spectral_coercivity_firex_supply_rule_source.py"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_OK" in result.stdout
