import Mathlib

/-
URF-core local capacity instance surface.

This file introduces the weakest instance-level theorem surface for the
localized `capacity` obligation after the local chain-rule instance surface:

  LocalCapacity_Instance_Surface

It does not replace the global `capacity` primitive in `urf_law3.lean`.
-/

structure LocalCapacityInstanceData where
  localMI : ℝ
  local_capacity_bound : localMI ≤ 1

theorem local_capacity_instance_surface
    (K : LocalCapacityInstanceData) :
    K.localMI ≤ 1 := by
  exact K.local_capacity_bound
