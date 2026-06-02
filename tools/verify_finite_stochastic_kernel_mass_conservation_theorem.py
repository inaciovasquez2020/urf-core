#!/usr/bin/env python3
import json
from pathlib import Path

ART = Path("artifacts/urf/finite_stochastic_kernel_mass_conservation_theorem_2026_06_02.json")
LEAN = Path("lean/URF/Foundation/FiniteStochasticKernelMassConservationTheorem.lean")
DOC = Path("docs/status/FINITE_STOCHASTIC_KERNEL_MASS_CONSERVATION_THEOREM_2026_06_02.md")
ROOT = Path("lean/URF.lean")

data = json.loads(ART.read_text(encoding="utf-8"))
lean = LEAN.read_text(encoding="utf-8")
doc = DOC.read_text(encoding="utf-8")
root = ROOT.read_text(encoding="utf-8")

assert data["object"] == "FiniteStochasticKernelMassConservationTheorem"
assert data["field"] == "finite stochastic systems / finite Markov kernels"
assert data["claim_class"] == "BOUNDED_UNCONDITIONAL_SCIENCE_DOMAIN_THEOREM"
assert data["unconditional"] is True
assert data["decision"] == "PASS"

for theorem in data["theorems"]:
    assert theorem in lean
    assert theorem in doc

assert "import URF.Foundation.FlagshipFiniteKernelTheoremSurface" in lean
assert "flagship_finite_kernel_theorem_surface" in lean
assert "Finset.univ.sum (K.transition a).prob = 1" in lean
assert "0 ≤ (K.transition a).prob b" in lean
assert "import URF.Foundation.FiniteStochasticKernelMassConservationTheorem" in root

for forbidden in [
    "does not solve unrestricted URF law closure",
    "does not solve empirical gravity validation",
    "does not solve plasma physics",
    "does not solve Hodge theory",
    "does not solve P vs NP",
    "does not solve any Clay problem",
]:
    assert forbidden in data["boundary"]

print("FINITE_STOCHASTIC_KERNEL_MASS_CONSERVATION_THEOREM_OK")
print(json.dumps(data, indent=2, sort_keys=True))
