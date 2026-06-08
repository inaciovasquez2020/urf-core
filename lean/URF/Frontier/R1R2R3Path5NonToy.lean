import Mathlib.Data.Fin.Basic

namespace URF.R1R2R3Path5

universe u

structure GeoConfig where
  Carrier       : Type u
  nonempty      : Nonempty Carrier
  adjacent      : Carrier → Carrier → Prop
  dist          : Carrier → Carrier → Nat
  dist_self     : ∀ x : Carrier, dist x x = 0
  fills         : Carrier → Carrier → Prop
  localType     : Carrier → Nat
  capacityBound : Nat

def R1_LongChordExclusion (G : GeoConfig.{u}) : Prop :=
  ∀ x y : G.Carrier, G.adjacent x y → G.dist x y ≤ 1

def R2_DiameterSepFilling (G : GeoConfig.{u}) : Prop :=
  ∀ x y : G.Carrier, 2 ≤ G.dist x y → ¬ G.fills x y

def R3_UniformLocalTypeCap (G : GeoConfig.{u}) : Prop :=
  ∀ x : G.Carrier, G.localType x ≤ G.capacityBound

structure SharedNonVacuousStructuralInvariant
    (G : GeoConfig.{u}) where
  edgeDistCode :
    ∀ x y : G.Carrier, G.adjacent x y → Fin (Nat.succ 1)
  edgeDistCode_eq :
    ∀ x y : G.Carrier, ∀ h : G.adjacent x y,
      G.dist x y = (edgeDistCode x y h).val
  filling_small_diameter :
    ∀ x y : G.Carrier, G.fills x y → G.dist x y < 2
  localTypeCode :
    G.Carrier → Fin (Nat.succ G.capacityBound)
  localType_eq_code :
    ∀ x : G.Carrier, G.localType x = (localTypeCode x).val
  nonvacuous :
    Nonempty G.Carrier

structure R1R2R3Certificate (G : GeoConfig.{u}) : Prop where
  r1 : R1_LongChordExclusion G
  r2 : R2_DiameterSepFilling G
  r3 : R3_UniformLocalTypeCap G

theorem r1_from_shared_structural_invariant
    (G : GeoConfig.{u})
    (I : SharedNonVacuousStructuralInvariant G) :
    R1_LongChordExclusion G := by
  intro x y hxy
  rw [I.edgeDistCode_eq x y hxy]
  exact Nat.lt_succ_iff.mp (I.edgeDistCode x y hxy).isLt

theorem r2_from_shared_structural_invariant
    (G : GeoConfig.{u})
    (I : SharedNonVacuousStructuralInvariant G) :
    R2_DiameterSepFilling G := by
  intro x y hdist hfill
  exact (not_lt_of_ge hdist) (I.filling_small_diameter x y hfill)

theorem r3_from_shared_structural_invariant
    (G : GeoConfig.{u})
    (I : SharedNonVacuousStructuralInvariant G) :
    R3_UniformLocalTypeCap G := by
  intro x
  rw [I.localType_eq_code x]
  exact Nat.lt_succ_iff.mp (I.localTypeCode x).isLt

theorem certificate_from_shared_structural_invariant
    (G : GeoConfig.{u})
    (I : SharedNonVacuousStructuralInvariant G) :
    R1R2R3Certificate G :=
  ⟨r1_from_shared_structural_invariant G I,
   r2_from_shared_structural_invariant G I,
   r3_from_shared_structural_invariant G I⟩

structure NonToyStructuralPackage
    (G : GeoConfig.{u}) where
  hasFourDistinct :
    ∃ a b c d : G.Carrier,
      a ≠ b ∧ a ≠ c ∧ a ≠ d ∧
      b ≠ c ∧ b ≠ d ∧ c ≠ d
  edgeWeight :
    ∀ x y : G.Carrier, G.adjacent x y → Fin (Nat.succ 1)
  dist_eq_weight :
    ∀ x y : G.Carrier, ∀ h : G.adjacent x y,
      G.dist x y = (edgeWeight x y h).val
  fills_within_one :
    ∀ x y : G.Carrier, G.fills x y → G.dist x y ≤ 1
  localTypeCode :
    G.Carrier → Fin (Nat.succ G.capacityBound)
  localType_eq_code :
    ∀ x : G.Carrier, G.localType x = (localTypeCode x).val
  adj_pair :
    ∃ x y : G.Carrier, G.adjacent x y
  sep_pair :
    ∃ x y : G.Carrier, 2 ≤ G.dist x y
  nonfill_sep_pair :
    ∃ x y : G.Carrier, 2 ≤ G.dist x y ∧ ¬ G.fills x y

def shared_invariant_from_nonToy
    (G : GeoConfig.{u})
    (H : NonToyStructuralPackage G) :
    SharedNonVacuousStructuralInvariant G where
  edgeDistCode := H.edgeWeight
  edgeDistCode_eq := H.dist_eq_weight
  filling_small_diameter := by
    intro x y hfill
    exact Nat.lt_succ_of_le (H.fills_within_one x y hfill)
  localTypeCode := H.localTypeCode
  localType_eq_code := H.localType_eq_code
  nonvacuous := G.nonempty

theorem certificate_from_nonToy_structural_package
    (G : GeoConfig.{u})
    (H : NonToyStructuralPackage G) :
    R1R2R3Certificate G :=
  certificate_from_shared_structural_invariant G
    (shared_invariant_from_nonToy G H)

structure RichNonToyStructuralPackage
    (G : GeoConfig.{u}) where
  base :
    NonToyStructuralPackage G
  genuineAdjacentDistinct :
    ∃ x y : G.Carrier, x ≠ y ∧ G.adjacent x y
  genuineSeparatedNonfilled :
    ∃ x y : G.Carrier, 3 ≤ G.dist x y ∧ ¬ G.fills x y

theorem certificate_from_rich_nonToy_structural_package
    (G : GeoConfig.{u})
    (H : RichNonToyStructuralPackage G) :
    R1R2R3Certificate G :=
  certificate_from_nonToy_structural_package G H.base

def pathDist (x y : Fin 5) : Nat :=
  if x.val ≤ y.val then y.val - x.val else x.val - y.val

theorem pathDist_self (x : Fin 5) : pathDist x x = 0 := by
  simp [pathDist]

def pathAdjacent (x y : Fin 5) : Prop :=
  pathDist x y = 1

def pathFills (x y : Fin 5) : Prop :=
  pathDist x y ≤ 1

def pathGeoConfig : GeoConfig where
  Carrier       := Fin 5
  nonempty      := ⟨(0 : Fin 5)⟩
  adjacent      := pathAdjacent
  dist          := pathDist
  dist_self     := pathDist_self
  fills         := pathFills
  localType     := fun x => x.val
  capacityBound := 4

def pathEdgeWeight
    (x y : Fin 5)
    (_ : pathAdjacent x y) :
    Fin (Nat.succ 1) :=
  ⟨1, by decide⟩

theorem pathDist_eq_weight
    (x y : Fin 5)
    (h : pathAdjacent x y) :
    pathDist x y = (pathEdgeWeight x y h).val := by
  simpa [pathEdgeWeight, pathAdjacent] using h

theorem pathFills_within_one
    (x y : Fin 5)
    (h : pathFills x y) :
    pathDist x y ≤ 1 :=
  h

def pathLocalTypeCode
    (x : Fin 5) :
    Fin (Nat.succ pathGeoConfig.capacityBound) :=
  x

theorem pathLocalType_eq_code
    (x : Fin 5) :
    pathGeoConfig.localType x = (pathLocalTypeCode x).val :=
  rfl

theorem pathHasFourDistinct :
    ∃ a b c d : pathGeoConfig.Carrier,
      a ≠ b ∧ a ≠ c ∧ a ≠ d ∧
      b ≠ c ∧ b ≠ d ∧ c ≠ d := by
  change ∃ a b c d : Fin 5,
      a ≠ b ∧ a ≠ c ∧ a ≠ d ∧
      b ≠ c ∧ b ≠ d ∧ c ≠ d
  exact
    ⟨(0 : Fin 5), (1 : Fin 5), (2 : Fin 5), (3 : Fin 5),
     by decide, by decide, by decide, by decide, by decide, by decide⟩

theorem pathAdj_pair :
    ∃ x y : pathGeoConfig.Carrier, pathGeoConfig.adjacent x y := by
  change ∃ x y : Fin 5, pathAdjacent x y
  refine ⟨(0 : Fin 5), (1 : Fin 5), ?_⟩
  simp [pathAdjacent, pathDist]

theorem pathSep_pair :
    ∃ x y : pathGeoConfig.Carrier, 2 ≤ pathGeoConfig.dist x y := by
  change ∃ x y : Fin 5, 2 ≤ pathDist x y
  exact ⟨(0 : Fin 5), (2 : Fin 5), by decide⟩

theorem pathNonfillSep_pair :
    ∃ x y : pathGeoConfig.Carrier,
      2 ≤ pathGeoConfig.dist x y ∧ ¬ pathGeoConfig.fills x y := by
  change ∃ x y : Fin 5, 2 ≤ pathDist x y ∧ ¬ pathFills x y
  refine ⟨(0 : Fin 5), (2 : Fin 5), ?_, ?_⟩
  · simp [pathDist]
  · simp [pathFills, pathDist]

def pathNonToyPackage : NonToyStructuralPackage pathGeoConfig where
  hasFourDistinct := pathHasFourDistinct
  edgeWeight := pathEdgeWeight
  dist_eq_weight := pathDist_eq_weight
  fills_within_one := pathFills_within_one
  localTypeCode := pathLocalTypeCode
  localType_eq_code := pathLocalType_eq_code
  adj_pair := pathAdj_pair
  sep_pair := pathSep_pair
  nonfill_sep_pair := pathNonfillSep_pair

theorem path5_R1_R2_R3_certificate :
    R1R2R3Certificate pathGeoConfig :=
  certificate_from_nonToy_structural_package
    pathGeoConfig
    pathNonToyPackage

theorem path5_genuineAdjacentDistinct :
    ∃ x y : pathGeoConfig.Carrier,
      x ≠ y ∧ pathGeoConfig.adjacent x y := by
  change ∃ x y : Fin 5, x ≠ y ∧ pathAdjacent x y
  refine ⟨(0 : Fin 5), (1 : Fin 5), ?_, ?_⟩
  · decide
  · simp [pathAdjacent, pathDist]

theorem path5_genuineSeparatedNonfilled :
    ∃ x y : pathGeoConfig.Carrier,
      3 ≤ pathGeoConfig.dist x y ∧ ¬ pathGeoConfig.fills x y := by
  change ∃ x y : Fin 5, 3 ≤ pathDist x y ∧ ¬ pathFills x y
  refine ⟨(0 : Fin 5), (3 : Fin 5), ?_, ?_⟩
  · simp [pathDist]
  · simp [pathFills, pathDist]

def path5RichNonToyPackage :
    RichNonToyStructuralPackage pathGeoConfig where
  base := pathNonToyPackage
  genuineAdjacentDistinct := path5_genuineAdjacentDistinct
  genuineSeparatedNonfilled := path5_genuineSeparatedNonfilled

theorem path5_rich_R1_R2_R3_certificate :
    R1R2R3Certificate pathGeoConfig :=
  certificate_from_rich_nonToy_structural_package
    pathGeoConfig
    path5RichNonToyPackage

structure RichClosedNonToyWitness where
  G :
    GeoConfig.{0}
  richPackage :
    RichNonToyStructuralPackage G
  certificate :
    R1R2R3Certificate G

def rich_closed_nonToy_exists :
    RichClosedNonToyWitness where
  G := pathGeoConfig
  richPackage := path5RichNonToyPackage
  certificate := path5_rich_R1_R2_R3_certificate

end URF.R1R2R3Path5
