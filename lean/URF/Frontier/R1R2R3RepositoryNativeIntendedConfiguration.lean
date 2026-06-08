import URF.Frontier.R1R2R3Path5NonToy

namespace URF.R1R2R3RepositoryNative

/--
Repository-native intended configuration instance.

This is not an unrestricted intended-configuration theorem.
It registers the already-merged repository object
`URF.R1R2R3Path5.pathGeoConfig` together with its rich non-toy package
and R1/R2/R3 certificate.
-/
structure RepositoryNativeIntendedConfigurationInstance where
  G :
    R1R2R3Path5.GeoConfig.{0}
  richPackage :
    R1R2R3Path5.RichNonToyStructuralPackage G
  certificate :
    R1R2R3Path5.R1R2R3Certificate G

def path5_repositoryNativeIntendedConfigurationInstance :
    RepositoryNativeIntendedConfigurationInstance where
  G :=
    R1R2R3Path5.pathGeoConfig
  richPackage :=
    R1R2R3Path5.path5RichNonToyPackage
  certificate :=
    R1R2R3Path5.path5_rich_R1_R2_R3_certificate

theorem path5_repositoryNativeIntendedConfiguration_certificate :
    R1R2R3Path5.R1R2R3Certificate
      R1R2R3Path5.pathGeoConfig :=
  path5_repositoryNativeIntendedConfigurationInstance.certificate

theorem repositoryNativeIntendedConfiguration_path5_closed :
    ∃ I : RepositoryNativeIntendedConfigurationInstance,
      I.G = R1R2R3Path5.pathGeoConfig :=
  ⟨path5_repositoryNativeIntendedConfigurationInstance, rfl⟩

end URF.R1R2R3RepositoryNative
