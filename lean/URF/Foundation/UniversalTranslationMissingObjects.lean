import URF.Foundation.UniversalTranslationTheorem

namespace URF
namespace Foundation

structure UniversalRigidityGrammarCandidate where
  grammar : RigidityGrammar

structure CanonicalDomainEncoderFamily where
  theoremWitness : UniversalTranslationTheorem

structure UniversalTranslationMissingObjects where
  candidate : UniversalRigidityGrammarCandidate
  encoders : CanonicalDomainEncoderFamily

def universalTranslationTheoremWitness
    (M : UniversalTranslationMissingObjects) :
    UniversalTranslationTheorem :=
  M.encoders.theoremWitness

theorem universal_translation_from_missing_objects
    (M : UniversalTranslationMissingObjects) :
    UniversalTranslationTheorem :=
  universalTranslationTheoremWitness M

theorem universal_translation_candidate_exists
    (M : UniversalTranslationMissingObjects) :
    ∃ G : RigidityGrammar, G = M.candidate.grammar := by
  exact ⟨M.candidate.grammar, rfl⟩

end Foundation
end URF
