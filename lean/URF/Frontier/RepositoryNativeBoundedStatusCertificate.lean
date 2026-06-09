import URF.Frontier.R1R2R3RepositoryNativeIntendedConfiguration
import URF.DescentSystem

namespace URF

theorem repository_native_bounded_status_certificate :
    (∃ I : R1R2R3RepositoryNative.RepositoryNativeIntendedConfigurationInstance,
      I.G = R1R2R3Path5.pathGeoConfig) ∧
    (∀ C : Configuration (Finset PlanarForbiddenMinorObstruction),
      ∃ n ≤ C.rank,
        (ConcretePlanarScientificDescentSystem.nstep n C).rank = 0) := by
  constructor
  · exact R1R2R3RepositoryNative.repositoryNativeIntendedConfiguration_path5_closed
  · exact ConcretePlanarSLVedPayload_scientific_closure_with_bound

end URF
