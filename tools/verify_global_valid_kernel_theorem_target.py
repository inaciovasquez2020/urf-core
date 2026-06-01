#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ARTIFACT = ROOT / "artifacts/urf/global_valid_kernel_theorem_target_2026_06_01.json"
DOC = ROOT / "docs/status/GLOBAL_VALID_KERNEL_THEOREM_TARGET_2026_06_01.md"
LEAN = ROOT / "lean/URF/Foundation/GlobalValidKernelTheoremTarget.lean"
ROOT_IMPORT = ROOT / "lean/URF.lean"

data = json.loads(ARTIFACT.read_text())
doc = DOC.read_text()
lean = LEAN.read_text()
root_import = ROOT_IMPORT.read_text()

assert data["artifact"] == "GLOBAL_VALID_KERNEL_THEOREM_TARGET_2026_06_01"
assert data["status"] == "TARGET_ONLY_GLOBAL_VALID_KERNEL_THEOREM_NOT_PROVED"
assert data["input_dependency"] == "CHANNEL_CAPACITY_BOUND_DERIVATION_2026_05_30"

assert data["closed_prerequisite"]["merged_pr"] == 362
assert data["closed_prerequisite"]["main_commit"] == "0c9d522"

required_missing = {
    "GLOBAL_VALID_KERNEL_PREDICATE",
    "PROBABILITY_KERNEL_SEMANTICS",
    "MEASURABLE_TRANSITION_SYSTEM",
    "FINITE_CAPACITY_BOUND_FOR_ALL_VALID_KERNELS",
    "FINITE_MI_CHAIN_COMPATIBILITY_FOR_VALID_KERNELS",
    "CMI_NONNEGATIVITY_COMPATIBILITY_FOR_VALID_KERNELS",
    "INFORMATION_THEORETIC_DERIVATION_FROM_PROBABILITY_MEASURES",
}
assert set(data["missing_objects"]) == required_missing

boundary = " ".join(data["boundary"]).lower()
for phrase in [
    "target only",
    "no global valid kernel theorem proved",
    "no unconditional channel-capacity theorem",
    "no global urf law 3 closure",
    "no information-theoretic derivation from probability measures",
    "no chronos-rr closure",
    "no h4.1/fgl closure",
    "no p vs np closure",
    "no clay-problem closure",
]:
    assert phrase in boundary

assert data["next_admissible_object"] == "GLOBAL_VALID_KERNEL_PREDICATE_OR_PROBABILITY_KERNEL_SEMANTICS"

assert "structure GlobalKernelObligation" in lean
assert "def AllKernelObligationsSupplied" in lean
assert "def GlobalValidKernelTheoremTarget" in lean
assert "theorem global_valid_kernel_theorem_target_registered" in lean
assert "axiom " not in lean
assert "sorry" not in lean

assert "import URF.Foundation.GlobalValidKernelTheoremTarget" in root_import

for phrase in [
    "TARGET_ONLY_GLOBAL_VALID_KERNEL_THEOREM_NOT_PROVED",
    "GLOBAL_VALID_KERNEL_PREDICATE",
    "PROBABILITY_KERNEL_SEMANTICS",
    "GLOBAL_VALID_KERNEL_PREDICATE_OR_PROBABILITY_KERNEL_SEMANTICS",
]:
    assert phrase in doc

print("GLOBAL_VALID_KERNEL_THEOREM_TARGET_OK")
