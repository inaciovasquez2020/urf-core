#!/bin/bash
# Read-only isolated Lean 4.27.0 H1 vacuity audit for an EXACT source blob.
# No Lake, downloads, tracked-file writes, Git operations or cache deletion.
# Requires python3, Git, and the already installed Lean 4.27.0 executable.
set -euo pipefail

REPO="$HOME/Desktop/GITHUB/urf-core-clean"
SOURCE="$REPO/lean/URF/H1Locality.lean"
LEAN="$HOME/.elan/toolchains/leanprover--lean4---v4.27.0/bin/lean"
EXPECTED="393b679a5d76daf755d0be683d4b10fa4332f6a2"

[[ -d "$REPO/.git" && -f "$SOURCE" && -x "$LEAN" ]] || {
  echo "BLOCKED := Repository, source, or Lean 4.27.0 unavailable"
  exit 2
}
command -v python3 >/dev/null && command -v git >/dev/null || {
  echo "BLOCKED := Python3 or Git unavailable"
  exit 2
}
BLOB="$(git -C "$REPO" hash-object lean/URF/H1Locality.lean)"
[[ "$BLOB" == "$EXPECTED" ]] || {
  echo "BLOCKED := Unexpected H1 source blob: $BLOB"
  exit 2
}
echo "HEAD := $(git -C "$REPO" rev-parse HEAD)"
echo "BRANCH := $(git -C "$REPO" branch --show-current)"
echo "GIT_STATUS_BEGIN"
git -C "$REPO" status --short
echo "GIT_STATUS_END"
echo "H1_SOURCE_BLOB := $BLOB"
"$LEAN" --version

AUDIT="$(mktemp -d -t urf-h1-isolated.XXXXXX)"
python3 -B - "$SOURCE" "$AUDIT/H1Isolated.lean" <<'PY'
import pathlib, sys
source = pathlib.Path(sys.argv[1]).read_text()
lines = source.splitlines()
declarations = (
    "structure FOkAdmissibleRefinementInterface where",
    "def H1Locality : Prop :=",
    "structure ConcreteRepositoryNativeFOkWitnessComponents where",
    "def ConcreteRepositoryNativeFOkWitnessComponentsValueOpenProblem : Prop :=",
)
sections = []
for declaration in declarations:
    matches = [n for n, line in enumerate(lines) if line == declaration]
    if len(matches) != 1:
        raise SystemExit("BLOCKED := Missing/duplicated declaration " + declaration)
    begin = matches[0]
    end = begin + 1
    while end < len(lines) and lines[end].strip():
        end += 1
    sections.append("\n".join(lines[begin:end]))

proof = r"""
namespace URF.H1Audit

theorem h1_trivial : URF.H1Locality := by
  let I : URF.FOkAdmissibleRefinementInterface := {
    k := 1
    k_pos := by decide
    RefinementProcedure := Unit
    FOkAdmissible := fun _ => True
  }
  exact ⟨I, by intro _; trivial⟩

def trivialComponents :
    URF.ConcreteRepositoryNativeFOkWitnessComponents where
  I := {
    k := 1
    k_pos := by decide
    RefinementProcedure := Unit
    FOkAdmissible := fun _ => True
  }
  procedure := ()
  all_admissible := by intro _; trivial
  RepositoryNativeSemanticBinding := Unit
  semantic_binding_witness := ()
  nonvacuous_semantic_content := True
  content_proof := True.intro

theorem nominal_gate_trivial :
    URF.ConcreteRepositoryNativeFOkWitnessComponentsValueOpenProblem := by
  exact ⟨trivialComponents⟩

#print axioms h1_trivial
#print axioms nominal_gate_trivial
end URF.H1Audit
"""
out = "import Init\n\nnamespace URF\n\n" + "\n\n".join(sections) + "\n\nend URF\n\n" + proof
pathlib.Path(sys.argv[2]).write_text(out)
print("EXACT_SOURCE_DECLARATIONS := 4")
print("SOURCE_EXTRACTION := PASS")
PY

echo "AUDIT_DIR := $AUDIT"
if (ulimit -t 90; "$LEAN" "$AUDIT/H1Isolated.lean") > "$AUDIT/lean.log" 2>&1; then
  cat "$AUDIT/lean.log"
else
  echo "ISOLATED_LEAN := FAILED_OR_RESOURCE_LIMIT"
  cat "$AUDIT/lean.log"
  echo "LOG := $AUDIT/lean.log"
  exit 1
fi
python3 -B - "$AUDIT/lean.log" <<'PY'
import pathlib, sys
log = pathlib.Path(sys.argv[1]).read_text()
allowed = {"propext", "Classical.choice", "Quot.sound"}
for name in (
    "URF.H1Audit.h1_trivial",
    "URF.H1Audit.nominal_gate_trivial",
):
    lines = [s for s in log.splitlines() if s.startswith("'" + name + "' ")]
    if len(lines) != 1:
        raise SystemExit("AXIOM_AUDIT := INCOMPLETE " + name)
    item = lines[0]
    if item == "'" + name + "' does not depend on any axioms":
        continue
    marker = "depends on axioms: ["
    if marker not in item or not item.endswith("]"):
        raise SystemExit("AXIOM_AUDIT := INCOMPLETE " + name)
    axioms = set(item.split(marker, 1)[1][:-1].split(", "))
    if not axioms <= allowed:
        raise SystemExit("AXIOM_AUDIT := FORBIDDEN " + repr(axioms))
print("ISOLATED_LEAN := PASS")
print("H1_VACUITY := LEAN_VERIFIED_ISOLATED")
print("NOMINAL_GATE_VACUITY := LEAN_VERIFIED_ISOLATED")
print("AXIOM_AUDIT := PASS")
PY

echo "SOURCE_MODIFICATIONS := NONE"
echo "GIT_MUTATIONS := NONE"
echo "LOG := $AUDIT/lean.log"
