import URF.Frontier.ArithmeticSpectralCoercivityFireX

namespace URF
namespace Frontier

/--
Backtrack-selected predecessor object for FireX.

This structure records the weakest predecessor obligation beneath `FireX`:
a source for the explicit supply rule from
`B.bridgeSuppliesInputHypothesisAssumption` to
`B.input.arithmeticSpectralBridgeHypothesis`.

It does not prove the analytic arithmetic-to-spectral bridge and does not claim
final coercivity closure.
-/
structure FireXSupplyRuleSource
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface) where
  source :
    B.bridgeSuppliesInputHypothesisAssumption →
      B.input.arithmeticSpectralBridgeHypothesis

/--
A supply-rule source induces a FireX input.

This is only a transport lemma from the backtrack-selected predecessor object
to the existing `FireX` structure.
-/
def FireX.ofSupplyRuleSource
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)
    (S : FireXSupplyRuleSource B) :
    FireX B where
  suppliesInputHypothesis := S.source

/--
Machine-readable checkpoint marker for repository verifiers.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_RECORDED : Bool := true

/--
Machine-readable boundary marker: this file records only the predecessor source
for the FireX supply rule.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_ONLY : Bool := true

/--
Machine-readable non-closure marker: the analytic bridge is not proved here.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_ANALYTIC_BRIDGE_CLOSED : Bool := false

/--
Machine-readable non-closure marker: final coercivity closure is not claimed.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_SOURCE_FINAL_CLOSURE_CLAIMED : Bool := false

end Frontier
end URF
