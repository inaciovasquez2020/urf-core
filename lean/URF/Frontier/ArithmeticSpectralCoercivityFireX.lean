import URF.Frontier.ArithmeticSpectralCoercivityBridgeToInputLemma

namespace URF
namespace Frontier

/--
FireX input for the arithmetic spectral coercivity bridge-to-input boundary.

This structure contains exactly the missing supply rule needed by the existing
conditional bridge-to-input lemma. It does not prove the analytic
arithmetic-to-spectral bridge and does not claim final coercivity closure.
-/
structure FireX
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface) where
  suppliesInputHypothesis :
    B.bridgeSuppliesInputHypothesisAssumption →
      B.input.arithmeticSpectralBridgeHypothesis

/--
FireX discharges only the existing bridge-to-input supply obligation.

This theorem is still conditional on `B.boundary`; FireX supplies only the
explicit implication from the bridge-supply assumption to the input bridge
hypothesis.
-/
theorem arithmeticSpectralCoercivity_fireX_supplies_inputHypothesis
    (B : ArithmeticSpectralCoercivityBridgeHypothesisInterface)
    (hB : B.boundary)
    (fireX : FireX B) :
    B.input.arithmeticSpectralBridgeHypothesis :=
  arithmeticSpectralCoercivityBridge_supplies_inputHypothesis_conditional
    B hB fireX.suppliesInputHypothesis

/--
Machine-readable checkpoint marker for repository verifiers.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_RECORDED : Bool := true

/--
Machine-readable boundary marker: FireX supplies only the explicit conditional
bridge-to-input rule.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_SUPPLY_RULE_ONLY : Bool := true

/--
Machine-readable non-closure marker: the analytic bridge is not proved here.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_ANALYTIC_BRIDGE_CLOSED : Bool := false

/--
Machine-readable non-closure marker: final coercivity closure is not claimed.
-/
def ARITHMETIC_SPECTRAL_COERCIVITY_FIREX_FINAL_CLOSURE_CLAIMED : Bool := false

end Frontier
end URF
