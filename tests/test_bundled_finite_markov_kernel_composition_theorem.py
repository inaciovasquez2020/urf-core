import json
import subprocess
from pathlib import Path

ART = Path("artifacts/urf/bundled_finite_markov_kernel_composition_theorem_2026_06_02.json")
VERIFY = Path("tools/verify_bundled_finite_markov_kernel_composition_theorem.py")

def test_artifact_records_bounded_unconditional_science_domain_theorem():
    data = json.loads(ART.read_text(encoding="utf-8"))
    assert data["object"] == "BundledFiniteMarkovKernelCompositionTheorem"
    assert data["unconditional"] is True
    assert data["claim_class"] == "BOUNDED_UNCONDITIONAL_SCIENCE_DOMAIN_THEOREM"
    assert data["field"] == "finite stochastic systems / finite Markov processes"

def test_verifier_passes():
    result = subprocess.run(["python3", str(VERIFY)], text=True, capture_output=True, check=True)
    assert "BUNDLED_FINITE_MARKOV_KERNEL_COMPOSITION_THEOREM_OK" in result.stdout
