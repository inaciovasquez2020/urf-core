import URF.Frontier.GeometricObservableConvergenceObligation
import URF.Frontier.ScalingLimitToEmergentMetricObligation

namespace URF
namespace Frontier
namespace MetricLikeCandidateConstructionObligation

/--
Candidate carrier for metric-like data extracted from controlled geometric
observables.

This is only a named target surface. It does not construct an emergent metric.
-/
structure MetricLikeCandidate where
  candidateNamed : Prop
  observable :
    GeometricObservableConvergenceObligation.GeometricObservable
  convergenceControl :
    GeometricObservableConvergenceObligation.ConvergenceControl
  scalingRegime :
    GeometricObservableConvergenceObligation.ScalingRegime

/--
Placeholder for the structural checks a future metric-like construction would
need before it could be promoted toward an emergent metric candidate.
-/
structure MetricLikeStructureControl where
  distanceOrKernelControlMissing : Prop
  symmetryControlMissing : Prop
  nondegeneracyControlMissing : Prop
  compatibilityWithScalingMissing : Prop

/--
Open obligation surface for constructing a metric-like candidate from geometric
observable convergence data.

This does not prove observable convergence, construct an emergent metric, prove
Lorentzian signature, recover an Einstein limit, derive field equations, or
solve gravity.
-/
structure Obligation where
  geometricObservableInputMissing : Prop
  convergenceControlInputMissing : Prop
  scalingRegimeInputMissing : Prop
  metricLikeStructureControlMissing : Prop
  candidateConstructionMissing : Prop
  compatibilityWithEmergentMetricTargetMissing : Prop
  boundaryNoMetricLikeCandidateConstructed : Prop
  boundaryNoGeometricObservableConvergenceProved : Prop
  boundaryNoEmergentMetricConstructed : Prop
  boundaryNoScalingLimitConverges : Prop
  boundaryNoLorentzianSignatureProved : Prop
  boundaryNoEinsteinLimitProved : Prop
  boundaryNoFieldEquationsDerived : Prop
  boundaryNoGravitySolved : Prop

theorem Obligation.boundaries
    (obligation : Obligation) :
    obligation.boundaryNoMetricLikeCandidateConstructed →
    obligation.boundaryNoGeometricObservableConvergenceProved →
    obligation.boundaryNoEmergentMetricConstructed →
    obligation.boundaryNoScalingLimitConverges →
    obligation.boundaryNoLorentzianSignatureProved →
    obligation.boundaryNoEinsteinLimitProved →
    obligation.boundaryNoFieldEquationsDerived →
    obligation.boundaryNoGravitySolved →
      obligation.boundaryNoMetricLikeCandidateConstructed ∧
      obligation.boundaryNoGeometricObservableConvergenceProved ∧
      obligation.boundaryNoEmergentMetricConstructed ∧
      obligation.boundaryNoScalingLimitConverges ∧
      obligation.boundaryNoLorentzianSignatureProved ∧
      obligation.boundaryNoEinsteinLimitProved ∧
      obligation.boundaryNoFieldEquationsDerived ∧
      obligation.boundaryNoGravitySolved :=
  fun hCandidate hConvergence hMetric hLimit hSignature hEinstein hField hGravity =>
    And.intro hCandidate
      (And.intro hConvergence
        (And.intro hMetric
          (And.intro hLimit
            (And.intro hSignature
              (And.intro hEinstein
                (And.intro hField hGravity))))))

theorem Obligation.missingBridge
    (obligation : Obligation) :
    obligation.geometricObservableInputMissing →
    obligation.convergenceControlInputMissing →
    obligation.scalingRegimeInputMissing →
    obligation.metricLikeStructureControlMissing →
    obligation.candidateConstructionMissing →
    obligation.compatibilityWithEmergentMetricTargetMissing →
      obligation.geometricObservableInputMissing ∧
      obligation.convergenceControlInputMissing ∧
      obligation.scalingRegimeInputMissing ∧
      obligation.metricLikeStructureControlMissing ∧
      obligation.candidateConstructionMissing ∧
      obligation.compatibilityWithEmergentMetricTargetMissing :=
  fun hObservable hControl hRegime hStructure hCandidate hCompatibility =>
    And.intro hObservable
      (And.intro hControl
        (And.intro hRegime
          (And.intro hStructure
            (And.intro hCandidate hCompatibility))))

end MetricLikeCandidateConstructionObligation
end Frontier
end URF
