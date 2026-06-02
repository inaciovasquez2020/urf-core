#!/usr/bin/env python3
import json
from pathlib import Path

ART = Path("artifacts/urf/finite_markov_kernel_composition_preserves_stochasticity_theorem_2026_06_02.json")
LEAN = Path("lean/URF/Foundation/FiniteMarkovKernelCompositionPreservesStochasticityTheorem.lean")
DOC = Path("docs/status/FINITE_MARKOV_KERNEL_COMPOSITION_PRESERVES_STOCHASTICITY_THEOREM_2026_06_02.md")
ROOT = Path("lean/URF.lean")

data = json.loads(ART.read_text(encoding="utf-8"))
lean = LEAN.read_text(encoding="utf-8")
doc = DOC.read_text(encoding="utf-8")
root = ROOT.read_text(encoding="utf-8")

assert data["object"] == "FiniteMarkovKernelCompositionPreservesStochasticityTheorem"
assert data["field"] == "finite stochastic systems / finite Markov processes"
assert data["claim_class"] == "BOUNDED_UNCONDITIONAL_SCIENCE_DOMAIN_THEOREM"
assert data["unconditional"] is True
assert data["decision"] == "PASS"

for name in data["definitions"]:
    assert name in lean
    assert name in doc

for theorem in data["theorems"]:
    assert theorem in lean
    assert theorem in doc

assert "import URF.Foundation.FiniteStochasticKernelMassConservationTheorem" in lean
assert "finite_stochastic_kernel_nonnegative_transition" in lean
assert "finite_stochastic_kernel_mass_conservation" in lean
assert "Finset.sum_comm" in lean
assert "Finset.mul_sum" in lean
assert "import URF.Foundation.FiniteMarkovKernelCompositionPreservesStochasticityTheorem" in root

for phrase in [
    "bounded finite-state Markov-kernel composition theorem only",
    "does not construct a bundled FinKernel unless separately requested",
    "does not solve unrestricted URF law closure",
    "does not solve empirical gravity validation",
    "does not solve plasma physics",
    "does not solve Hodge theory",
    "does not solve P vs NP",
    "does not solve any Clay problem",
]:
    assert phrase in data["boundary"]

print("FINITE_MARKOV_KERNEL_COMPOSITION_PRESERVES_STOCHASTICITY_THEOREM_OK")
print(json.dumps(data, indent=2, sort_keys=True))
