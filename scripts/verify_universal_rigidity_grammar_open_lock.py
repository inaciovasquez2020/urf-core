#!/usr/bin/env python3
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parents[1]

lean = ROOT / "lean/URF/Foundation/UniversalRigidityGrammarData.lean"
artifact = ROOT / "artifacts/urf/universal_rigidity_grammar_open_lock_2026_05_19.json"
status = ROOT / "docs/status/UNIVERSAL_RIGIDITY_GRAMMAR_OPEN_LOCK_2026_05_19.md"

for path in (lean, artifact, status):
    if not path.exists():
        raise SystemExit(f"missing required file: {path}")

lean_text = lean.read_text()

for token in [
    "structure UniversalRigidityGrammarData",
    "structure AdmissibleDomainEncoder",
    "def UniversalTranslationTheorem",
    "theorem UniversalTranslationTheorem_conditional_on_equal_ranges",
    "structure UnrestrictedUFEG",
    "inductive OpenProblemPromotionLock",
    "theorem UnrestrictedUFEG_open_problem_lock",
    "OpenProblemPromotionLock.frontierOpen",
]:
    if token not in lean_text:
        raise SystemExit(f"missing Lean token: {token}")

for forbidden in ["axiom ", "sorry", "admit"]:
    if forbidden in lean_text:
        raise SystemExit(f"forbidden Lean token present: {forbidden}")

data = json.loads(artifact.read_text())

if data["status"] != "CONDITIONAL_DEFINITIONS_AND_OPEN_PROBLEM_LOCK":
    raise SystemExit("unexpected artifact status")

if data["promotion_lock"] != "frontierOpen":
    raise SystemExit("promotion lock must remain frontierOpen")

if data["terminal_missing_theorem"] != "UnrestrictedUFEG":
    raise SystemExit("terminal missing theorem must be UnrestrictedUFEG")

status_text = status.read_text()

for boundary in [
    "Does not prove:",
    "existence of a universal RigidityGrammar",
    "unconditional UniversalTranslationTheorem",
    "unrestricted UniversalFiberEntropyGap",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    if boundary not in status_text:
        raise SystemExit(f"missing boundary token: {boundary}")

print("Universal rigidity grammar open lock verified.")
