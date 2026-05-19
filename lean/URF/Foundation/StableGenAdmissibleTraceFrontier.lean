import URF.Foundation.CapacitySoundnessReduction

universe u v w

namespace URF
namespace Foundation
namespace StableGenAdmissibleTraceFrontier

open CapacitySoundnessReduction

structure StableTraceCertificate (X : CapacityInterface.{u, v, w}) where
  traceOf : X.Generator → X.Trace
  admissible : ∀ g : X.Generator, X.StableGen g → X.Adm (traceOf g)
  encodes : ∀ g : X.Generator, X.StableGen g → X.Encodes (traceOf g) g

def StableTraceCertificateExists (X : CapacityInterface.{u, v, w}) : Prop :=
  Nonempty (StableTraceCertificate X)

theorem stableGenAdmissibleTrace_from_certificate
    {X : CapacityInterface.{u, v, w}}
    (cert : StableTraceCertificate X) :
    StableGenAdmissibleTrace X := by
  intro g hg
  exact ⟨cert.traceOf g, cert.admissible g hg, cert.encodes g hg⟩

theorem stableGenAdmissibleTrace_from_certificate_exists
    {X : CapacityInterface.{u, v, w}}
    (hcert : StableTraceCertificateExists X) :
    StableGenAdmissibleTrace X := by
  rcases hcert with ⟨cert⟩
  exact stableGenAdmissibleTrace_from_certificate cert

theorem capacitySoundness_from_certificate
    {X : CapacityInterface.{u, v, w}}
    (hbounded : BddAbove (AdmissibleInformationSet X))
    (hcert : StableTraceCertificateExists X) :
    CapacitySoundness X := by
  exact capacitySoundness_from_stableTrace
    X hbounded
    (stableGenAdmissibleTrace_from_certificate_exists hcert)

theorem capacityObstruction_from_certificate
    {X : CapacityInterface.{u, v, w}}
    (hbounded : BddAbove (AdmissibleInformationSet X))
    (hcert : StableTraceCertificateExists X)
    {g : X.Generator}
    (hover : C_adm X < X.I g) :
    ¬ X.StableGen g := by
  exact capacity_obstruction_contrapositive
    X hbounded
    (stableGenAdmissibleTrace_from_certificate_exists hcert)
    hover

end StableGenAdmissibleTraceFrontier
end Foundation
end URF
