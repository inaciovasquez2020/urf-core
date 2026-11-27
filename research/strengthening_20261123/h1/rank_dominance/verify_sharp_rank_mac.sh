#!/bin/bash
set -euo pipefail
REPO="$HOME/Desktop/GITHUB/urf-core-clean"
SRC="lean/URF/DescentSystem.lean"
EXPECTED="a40427cc407f990040f0cf87870b2e9ccbde0b69"
PIN="a3a10db0e9d66acbebf76c5e6a135066525ac900"
test -d "$REPO/.git" && test -f "$REPO/$SRC" || { echo 'BLOCKED := Repository/source missing'; exit 2; }
cd "$REPO"
echo "HEAD := $(git rev-parse HEAD)"
echo "BRANCH := $(git branch --show-current)"
echo 'STATUS_BEGIN'
git status --short
echo 'STATUS_END'
test "$(git hash-object "$SRC")" = "$EXPECTED" || { echo 'BLOCKED := Source blob changed'; exit 2; }
test "$(cat lean-toolchain)" = "leanprover/lean4:v4.27.0" || { echo 'BLOCKED := Toolchain mismatch'; exit 2; }
test "$(git -C .lake/packages/mathlib rev-parse HEAD)" = "$PIN" || { echo 'BLOCKED := Mathlib pin mismatch'; exit 2; }
AUDIT="$(mktemp -d -t urf-rank-sharp.XXXXXX)"
python3 -B - "$SRC" "$AUDIT/SharpRank.lean" <<'PY'
from pathlib import Path
import sys
lines = Path(sys.argv[1]).read_text().splitlines()
sections = []
for declaration in (
    'structure Configuration ',
    'structure FiniteObstructionSelector ',
    'def finiteObstructionDescentStep',
    'def finiteObstructionDescentNstep',
):
    matches = [i for i, s in enumerate(lines) if s.startswith(declaration)]
    if len(matches) != 1:
        raise SystemExit('BLOCKED := Unexpected source declaration '+declaration)
    i = matches[0]
    j = i+1
    while j < len(lines) and lines[j].strip():
        j+=1
    sections.append('\n'.join(lines[i:j]))
proof = r'''
namespace SharpRankAudit

theorem step_card
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentStep selector C).data.card = C.data.card - 1 := by
  by_cases hd : C.data = ∅
  · simp [finiteObstructionDescentStep, hd]
  · have hm := selector.choose_mem C.data hd
    simp only [finiteObstructionDescentStep, dif_neg hd]
    exact Finset.card_erase_of_mem hm

theorem step_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentStep selector C).rank = C.rank - 1 := by
  by_cases hd : C.data = ∅
  · simp [finiteObstructionDescentStep, hd]
  · simp [finiteObstructionDescentStep, hd]

theorem nstep_card
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O) :
    ∀ (n : Nat) (C : Configuration (Finset O)),
      (finiteObstructionDescentNstep selector n C).data.card = C.data.card - n := by
  intro n
  induction n with
  | zero =>
      intro C
      rfl
  | succ n ih =>
      intro C
      change (finiteObstructionDescentNstep selector n
        (finiteObstructionDescentStep selector C)).data.card = C.data.card - (n + 1)
      rw [ih (finiteObstructionDescentStep selector C), step_card selector C]
      omega

theorem nstep_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O) :
    ∀ (n : Nat) (C : Configuration (Finset O)),
      (finiteObstructionDescentNstep selector n C).rank = C.rank - n := by
  intro n
  induction n with
  | zero =>
      intro C
      rfl
  | succ n ih =>
      intro C
      change (finiteObstructionDescentNstep selector n
        (finiteObstructionDescentStep selector C)).rank = C.rank - (n + 1)
      rw [ih (finiteObstructionDescentStep selector C), step_rank selector C]
      omega

theorem rank_zero_at_initial_rank
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentNstep selector C.rank C).rank = 0 := by
  rw [nstep_rank selector C.rank C]
  omega

theorem data_empty_at_initial_rank_iff
    {O : Type u} [DecidableEq O]
    (selector : FiniteObstructionSelector O)
    (C : Configuration (Finset O)) :
    (finiteObstructionDescentNstep selector C.rank C).data = ∅ ↔
      C.data.card ≤ C.rank := by
  constructor
  · intro h
    have hz : (finiteObstructionDescentNstep selector C.rank C).data.card = 0 := by
      simp [h]
    rw [nstep_card selector C.rank C] at hz
    omega
  · intro h
    apply Finset.card_eq_zero.mp
    rw [nstep_card selector C.rank C]
    omega

end SharpRankAudit
end URF

#print axioms URF.SharpRankAudit.step_card
#print axioms URF.SharpRankAudit.step_rank
#print axioms URF.SharpRankAudit.nstep_card
#print axioms URF.SharpRankAudit.nstep_rank
#print axioms URF.SharpRankAudit.rank_zero_at_initial_rank
#print axioms URF.SharpRankAudit.data_empty_at_initial_rank_iff
'''
Path(sys.argv[2]).write_text('import Mathlib.Data.Finset.Card\n\nnamespace URF\nuniverse u\n\n' + '\n\n'.join(sections) + '\n\n' + proof)
print('EXACT_DECLARATIONS := 4')
print('PROPOSED_THEOREMS := 6')
PY
echo '=== LEAN COMPILATION ==='
if (ulimit -t 120; lake env lean "$AUDIT/SharpRank.lean") > "$AUDIT/lean.log" 2>&1; then
  cat "$AUDIT/lean.log"
else
  echo 'SHARP_RANK := FAILED_OR_RESOURCE_LIMIT'
  grep -m 1 'error:' "$AUDIT/lean.log" || tail -10 "$AUDIT/lean.log"
  echo "LOG := $AUDIT/lean.log"
  exit 1
fi
python3 -B - "$AUDIT/lean.log" <<'PY'
from pathlib import Path
import sys
s=Path(sys.argv[1]).read_text()
allowed={'propext','Classical.choice','Quot.sound'}
names=['step_card','step_rank','nstep_card','nstep_rank','rank_zero_at_initial_rank','data_empty_at_initial_rank_iff']
if 'error:' in s:
    raise SystemExit('FAILED := Compiler error')
for name in names:
    prefix="'URF.SharpRankAudit."+name+"' "
    rows=[l for l in s.splitlines() if l.startswith(prefix)]
    if len(rows)!=1:
        raise SystemExit('AXIOM_AUDIT := INCOMPLETE '+name)
    tail=rows[0][len(prefix):]
    if tail=='does not depend on any axioms':
        continue
    marker='depends on axioms: ['
    if not tail.startswith(marker) or not tail.endswith(']'):
        raise SystemExit('AXIOM_AUDIT := INCOMPLETE '+name)
    axioms=set(tail[len(marker):-1].split(', '))
    if not axioms <= allowed:
        raise SystemExit('FORBIDDEN_AXIOMS := '+repr(axioms))
print('SHARP_RANK_IFF := LEAN_VERIFIED_ISOLATED')
print('AXIOM_AUDIT := PASS 6/6')
PY
echo 'STATUS_END'
git status --short
echo 'GIT_MUTATIONS := NONE'
echo "LOG := $AUDIT/lean.log"
