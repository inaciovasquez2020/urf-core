#!/usr/bin/env python3
from pathlib import Path
import json
import re
import sys

BASE = Path(__file__).resolve().parent.parent
LEAN_FILE = BASE / "lean/URF/Foundation/FlagshipFiniteKernelTheoremSurface.lean"
ARTIFACT = BASE / "artifacts/urf/urf_flagship_finite_kernel_theorem_surface_2026_06_02.json"
STATUS_MD = BASE / "docs/status/URF_FLAGSHIP_FINITE_KERNEL_THEOREM_SURFACE_2026_06_02.md"
GRAPH = BASE / "artifacts/urf/urf_flagship_finite_kernel_theorem_dependency_graph_2026_06_02.dot"

QUARANTINED_PATTERNS = [
    r"\bgravity\b",
    r"\bcosmology\b",
    r"\beinstein\b",
    r"\bcollapse\b",
    r"\bempirical\s+validation\b",
    r"\bobservational\s+validation\b",
    r"\bnasa\b",
    r"\bmascon\b",
    r"\bgrace\b",
    r"\bACT\b",
    r"\bDESI\b",
    r"\bhodge\b",
    r"\bclay\b",
    r"\bp\s+vs\s+np\b",
    r"\bunrestricted\s+urf\s+closure\b"
]

FORBIDDEN_PROOF_TERMS = ["axiom", "admit", "sorry"]

REQUIRED_SYMBOLS = [
    "structure FinDist",
    "structure FinKernel",
    "theorem flagship_finite_kernel_theorem_surface",
    "(K.transition a).nonneg b",
    "(K.transition a).sum_one"
]

VALID_CLASSES = {
    "NONTRIVIAL_LAKE_REGISTERED_LEAN_CHECKED_FLAGSHIP_THEOREM",
    "NONTRIVIAL_STANDALONE_LEAN_CHECKED_FLAGSHIP_SURFACE_PENDING_DEPENDENCY_ANCHOR",
    "NONTRIVIAL_LEAN_BACKED_FLAGSHIP_THEOREM",
    "TRIVIAL_SCOPE_MARKER_ONLY_MINIMAL_MISSING_LEMMA_RECORDED"
}

def strip_lean_comments(text: str) -> str:
    text = re.sub(r"/-.*?-/", " ", text, flags=re.DOTALL)
    text = re.sub(r"--[^\n]*", "", text)
    return text

def fail(msg: str) -> None:
    print(f"ERROR: {msg}")
    sys.exit(1)

for path in [LEAN_FILE, ARTIFACT, STATUS_MD, GRAPH]:
    if not path.exists():
        fail(f"missing required file: {path.relative_to(BASE)}")

lean_raw = LEAN_FILE.read_text(encoding="utf-8")
lean_code = strip_lean_comments(lean_raw)
artifact_raw = ARTIFACT.read_text(encoding="utf-8")
status_raw = STATUS_MD.read_text(encoding="utf-8")
graph_raw = GRAPH.read_text(encoding="utf-8")
data = json.loads(artifact_raw)

for term in FORBIDDEN_PROOF_TERMS:
    if re.search(rf"\b{re.escape(term)}\b", lean_code):
        fail(f"forbidden Lean proof token in code: {term}")

for pattern in QUARANTINED_PATTERNS:
    if re.search(pattern, lean_code, re.IGNORECASE):
        fail(f"quarantined pattern in Lean code: {pattern}")

for pattern in QUARANTINED_PATTERNS:
    if re.search(pattern, data.get("theorem_statement", ""), re.IGNORECASE):
        fail(f"quarantined pattern in theorem statement: {pattern}")

for symbol in REQUIRED_SYMBOLS:
    if symbol not in lean_raw:
        fail(f"missing required Lean symbol/body fragment: {symbol}")

if re.search(
    r"theorem\s+flagship_finite_kernel_theorem_surface[\s\S]*?:\s*True\s*:=",
    lean_code,
):
    fail("flagship theorem proves only True")

tc = data.get("theorem_class") or data.get("status")
if tc not in VALID_CLASSES:
    fail(f"invalid theorem_class/status: {tc}")

if data.get("is_trivially_true_only") is True:
    fail("artifact records trivially true theorem")

for key in ["uses_axiom", "uses_admit", "uses_sorry", "quarantined_terms_detected"]:
    if data.get(key) is True:
        fail(f"artifact records forbidden flag: {key}")

for required in ["FinDist.nonneg", "FinDist.sum_one", "flagship_finite_kernel_theorem_surface"]:
    if required not in graph_raw:
        fail(f"dependency graph missing: {required}")

if "import URF.Foundation.FlagshipFiniteKernelTheoremSurface" not in status_raw:
    fail("status doc missing lake import check")

if data.get("dependency_mode") != "lake_registered_importable_module":
    fail("artifact dependency_mode is not lake_registered_importable_module")

if data.get("minimal_missing_dependency_anchor") != "NONE":
    fail("artifact minimal_missing_dependency_anchor is not NONE")

if data.get("root_import_file") != "lean/URF.lean":
    fail("artifact root_import_file is not lean/URF.lean")

print("URF_FLAGSHIP_FINITE_KERNEL_THEOREM_SURFACE_OK")
print(json.dumps({
    "decision": "PASS",
    "theorem_class": tc,
    "theorem_name": data.get("theorem_name"),
    "dependency_mode": data.get("dependency_mode"),
    "next_admissible_object": data.get("next_admissible_object")
}, indent=2, sort_keys=True))
