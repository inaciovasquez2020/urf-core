import Mathlib

/-
URF-core local chain-rule instance surface.

This file introduces the weakest instance-level theorem surface for the
localized `chain_rule` obligation after the local URF Law 3 instance:

  LocalChainRule_Instance_Surface

It does not replace the global `chain_rule` primitive in `urf_law3.lean`.
-/

structure LocalChainRuleInstanceData (T : ℕ) where
  localCMI : ℕ → ℝ

def localChainRuleMI
    {T : ℕ}
    (K : LocalChainRuleInstanceData T) : ℝ :=
  Finset.sum (Finset.range T) (fun t => K.localCMI t)

theorem local_chain_rule_instance_surface
    {T : ℕ}
    (K : LocalChainRuleInstanceData T) :
    localChainRuleMI K = Finset.sum (Finset.range T) (fun t => K.localCMI t) := by
  rfl
