# URF-Core Law 3 Entropy Non-Amplification — 2026-05-15

STATUS := THEOREM_CLOSED

TARGET_FILE :=
  urf_law3.lean

CLOSED_THEOREM :=
  urf_law3

REMOVED_ADMITS :=
  1

PROOF_USES :=
  capacity
  chain_rule
  cmi_nonneg
  Finset.single_le_sum

EXPECTED_OBLIGATION_COUNTS :=
  axiom_count := 52
  admit_count := 9
  sorry_count := 0

BOUNDARY :=
  adds_six_structural_axioms_for_law3_symbols
  law3_closed_relative_to_existing_axioms
  does_not_discharge_capacity_axiom
  does_not_discharge_chain_rule_axiom
  does_not_discharge_cmi_nonneg_axiom
  does_not_close_whole_URF
  does_not_close_Chronos_RR
  does_not_close_H4_1_FGL
  does_not_close_P_vs_NP
  does_not_close_Clay_problem
