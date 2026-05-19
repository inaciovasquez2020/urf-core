import URF.Foundation.StableTraceCertificateEquivalence

universe u v w

namespace URF
namespace Foundation
namespace UnconditionalStableTraceNoGo

open CapacitySoundnessReduction
open StableGenAdmissibleTraceFrontier
open StableTraceCertificateEquivalence

theorem no_unconditional_certificate_from_stable_trace :
    ¬ (∀ X : CapacityInterface.{0, 0, 0},
        StableGenAdmissibleTrace X → StableTraceCertificateExists X) := by
  intro h
  exact emptyTraceCountermodel_no_certificate
    (h emptyTraceCounterinterface emptyTraceCountermodel_stableGenAdmissibleTrace)

theorem no_unconditional_certificate_exists_all_interfaces :
    ¬ (∀ X : CapacityInterface.{0, 0, 0},
        StableTraceCertificateExists X) := by
  intro h
  exact emptyTraceCountermodel_no_certificate (h emptyTraceCounterinterface)

def noStableTraceCounterinterface : CapacityInterface.{0, 0, 0} where
  State := Unit
  Generator := Unit
  Trace := Empty
  Adm := fun _ => False
  Encodes := fun _ _ => False
  StableGen := fun _ => True
  I := fun _ => 0

theorem noStableTraceCountermodel_no_stableGenAdmissibleTrace :
    ¬ StableGenAdmissibleTrace noStableTraceCounterinterface := by
  intro h
  obtain ⟨τ, _, _⟩ := h () trivial
  exact Empty.elim τ

theorem no_unconditional_stableGenAdmissibleTrace_all_interfaces :
    ¬ (∀ X : CapacityInterface.{0, 0, 0},
        StableGenAdmissibleTrace X) := by
  intro h
  exact noStableTraceCountermodel_no_stableGenAdmissibleTrace
    (h noStableTraceCounterinterface)

theorem no_unconditional_joint_solution :
    ¬ (∀ X : CapacityInterface.{0, 0, 0},
        StableTraceCertificateExists X ∧ StableGenAdmissibleTrace X) := by
  intro h
  exact emptyTraceCountermodel_no_certificate (h emptyTraceCounterinterface).1

end UnconditionalStableTraceNoGo
end Foundation
end URF
