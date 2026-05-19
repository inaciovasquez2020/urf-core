# Unconditional Stable Trace No-Go

Status: `REFUTED_UNCONDITIONAL_TARGET`

Closed:
- refutes unconditional `StableGenAdmissibleTrace → StableTraceCertificateExists`
- refutes unconditional `StableTraceCertificateExists`
- refutes unconditional `StableGenAdmissibleTrace`
- refutes unconditional joint solution

Countermodels:
```lean
emptyTraceCounterinterface
noStableTraceCounterinterface
Formal meaning:
The unconditional targets are false for arbitrary `CapacityInterface`.

The unconditional targets are false for arbitrary CapacityInterface.
Surviving conditional result:
[Inhabited X.Trace] →
StableGenAdmissibleTrace X ↔ StableTraceCertificateExists X
Boundary:
This is a no-go theorem, not a closure theorem.
Does not prove:
- unconditional `StableTraceCertificateExists`
- unconditional `StableGenAdmissibleTrace`
- unrestricted `UniversalFiberEntropyGap`
- unrestricted Chronos-RR
- unrestricted H4.1/FGL
- P vs NP
- any Clay problem
