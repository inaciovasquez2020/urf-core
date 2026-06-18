import URF.Frontier.ArithmeticSpectralCoercivityFireXSupplyRuleSource

namespace URF
namespace Frontier

/--
Concrete source-obligation target for `FireXSupplyRuleSource.source`.

This records only the conditional obligation needed one level below the
FireX supply-rule source. It does not prove the analytic arithmetic-to-spectral
bridge and does not claim final coercivity closure.
-/
structure FireXSupplyRuleConcreteSourceObligation
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface) where
  sourceFromExistingAssumptions :
    B.arithmeticAssumptions →
    B.spectralAssumptions →
    B.bridgeTransfersArithmeticToSpectralAssumption →
    B.boundaryNoAnalyticBridgeProof →
    B.boundaryNoFinalCoercivityClosureClaim →
      B.bridgeSuppliesInputHypothesisAssumption →
        B.input.arithmeticSpectralBridgeHypothesis

/--
A concrete source obligation induces the predecessor source only after the
non-source assumptions are supplied explicitly.

The resulting source remains conditional on
`B.bridgeSuppliesInputHypothesisAssumption`.
-/
def FireXSupplyRuleSource.ofConcreteSourceObligation
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)
    (O : FireXSupplyRuleConcreteSourceObligation B)
    (harith : B.arithmeticAssumptions)
    (hspec : B.spectralAssumptions)
    (htransfer : B.bridgeTransfersArithmeticToSpectralAssumption)
    (hNoBridge : B.boundaryNoAnalyticBridgeProof)
    (hNoClosure : B.boundaryNoFinalCoercivityClosureClaim) :
    FireXSupplyRuleSource B where
  source := O.sourceFromExistingAssumptions
    harith hspec htransfer hNoBridge hNoClosure

/--
Conditional application of the concrete source obligation.

This theorem only applies the supplied obligation; it does not construct that
obligation from analysis.
-/
theorem fireXSupplyRuleConcreteSourceObligation_supplies_inputHypothesis_conditional
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)
    (O : FireXSupplyRuleConcreteSourceObligation B)
    (harith : B.arithmeticAssumptions)
    (hspec : B.spectralAssumptions)
    (htransfer : B.bridgeTransfersArithmeticToSpectralAssumption)
    (hNoBridge : B.boundaryNoAnalyticBridgeProof)
    (hNoClosure : B.boundaryNoFinalCoercivityClosureClaim)
    (hsource : B.bridgeSuppliesInputHypothesisAssumption) :
    B.input.arithmeticSpectralBridgeHypothesis :=
  O.sourceFromExistingAssumptions
    harith hspec htransfer hNoBridge hNoClosure hsource

def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_RECORDED :
    Bool := true

def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_ONLY :
    Bool := true

def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_ANALYTIC_BRIDGE_CLOSED :
    Bool := false

def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_CONCRETE_SOURCE_OBLIGATION_FINAL_COERCIVITY_CLOSED :
    Bool := false

end Frontier
end URF
