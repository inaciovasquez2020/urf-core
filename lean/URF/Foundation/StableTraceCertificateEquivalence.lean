import URF.Foundation.StableGenAdmissibleTraceFrontier

universe u v w

namespace URF
namespace Foundation
namespace StableTraceCertificateEquivalence

open CapacitySoundnessReduction
open StableGenAdmissibleTraceFrontier

noncomputable theorem stableGenAdmissibleTrace_to_certificate
    {X : CapacityInterface.{u, v, w}}
    [Inhabited X.Trace]
    (h : StableGenAdmissibleTrace X) :
    StableTraceCertificateExists X := by
  classical
  let f : X.Generator → X.Trace :=
    fun g => if hg : X.StableGen g then Classical.choose (h g hg) else default
  refine ⟨{
    traceOf := f
    admissible := ?_
    encodes := ?_
  }⟩
  · intro g hg
    have hf : f g = Classical.choose (h g hg) := by
      dsimp [f]
      rw [dif_pos hg]
    rw [hf]
    exact (Classical.choose_spec (h g hg)).1
  · intro g hg
    have hf : f g = Classical.choose (h g hg) := by
      dsimp [f]
      rw [dif_pos hg]
    rw [hf]
    exact (Classical.choose_spec (h g hg)).2

noncomputable theorem stableGenAdmissibleTrace_iff_certificateExists
    {X : CapacityInterface.{u, v, w}}
    [Inhabited X.Trace] :
    StableGenAdmissibleTrace X ↔ StableTraceCertificateExists X := by
  constructor
  · exact stableGenAdmissibleTrace_to_certificate
  · exact stableGenAdmissibleTrace_from_certificate_exists

noncomputable theorem stableTraceCertificateExists_iff_stableGenAdmissibleTrace
    {X : CapacityInterface.{u, v, w}}
    [Inhabited X.Trace] :
    StableTraceCertificateExists X ↔ StableGenAdmissibleTrace X := by
  constructor
  · exact stableGenAdmissibleTrace_from_certificate_exists
  · exact stableGenAdmissibleTrace_to_certificate

def emptyTraceCounterinterface : CapacityInterface.{0, 0, 0} where
  State := Unit
  Generator := Unit
  Trace := Empty
  Adm := fun _ => False
  Encodes := fun _ _ => False
  StableGen := fun _ => False
  I := fun _ => 0

theorem emptyTraceCountermodel_stableGenAdmissibleTrace :
    StableGenAdmissibleTrace emptyTraceCounterinterface := by
  intro g hg
  cases hg

theorem emptyTraceCountermodel_no_certificate :
    ¬ StableTraceCertificateExists emptyTraceCounterinterface := by
  intro h
  rcases h with ⟨cert⟩
  exact Empty.elim (cert.traceOf ())

theorem emptyTraceCountermodel_no_trace_inhabited :
    ¬ Nonempty emptyTraceCounterinterface.Trace := by
  intro h
  rcases h with ⟨x⟩
  exact Empty.elim x

end StableTraceCertificateEquivalence
end Foundation
end URF
