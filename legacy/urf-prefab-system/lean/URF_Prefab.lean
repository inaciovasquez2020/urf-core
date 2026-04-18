universe u

namespace URF

constant Var : Type u

constant H   : Var → ℝ
constant I   : Var → Var → ℝ
constant I_c : Var → Var → Var → ℝ
constant Cmax : Var → ℝ

axiom H_nonneg  (X : Var) : 0 ≤ H X
axiom I_nonneg  (X Y : Var) : 0 ≤ I X Y
axiom I_c_nonneg (X Y Z : Var) : 0 ≤ I_c X Y Z

axiom urf_cmi_subadditivity (A B C : Var) :
  I_c A B C ≤ I A B ∧ I A B ≤ H A ∧ H A ≤ Cmax A

structure Prefab :=
  (X : Var)
  (C : ℝ)

def Prefab.capacity (P : Prefab) : ℝ := P.C

def SystemCapacity : List Prefab → ℝ
| [] => 0
| (p :: ps) => p.capacity + SystemCapacity ps

axiom PCA (S : List Prefab) :
  ∀ R, True → True
-- placeholder: later replace with full entropy inequality

end URF
