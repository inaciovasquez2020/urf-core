# URF-Core Admissible Normalization Boundaries — 2026-05-15

STATUS := TEXTUAL_NONCOMPILED_ADMITS_REMOVED_EXPLICIT_ASSUMPTION_BOUNDARIES

TARGET_FILE :=
  admissible/lean/URFAdmissible.lean

REMOVED_ADMITS :=
  2

TARGET_THEOREMS :=
  TM_normalization
  RAM_normalization

REPLACEMENT_ASSUMPTIONS :=
  TM_normalization_assumption
  RAM_normalization_assumption

THEOREM_CLOSURE :=
  false

LEAN_COMPILED_TARGET_FILE :=
  false

BOUNDARY :=
  target_file_is_not_standalone_Lean_compiled
  converted_two_admits_to_explicit_assumptions
  does_not_discharge_TM_normalization
  does_not_discharge_RAM_normalization
  does_not_close_whole_URF
  does_not_close_Chronos_RR
  does_not_close_H4_1_FGL
  does_not_close_P_vs_NP
  does_not_close_Clay_problem
