# Stable Trace Certificate Equivalence

Status: `CONDITIONAL / TRACE_INHABITED_EQUIVALENCE`

Closed structural step:
- proves `StableGenAdmissibleTrace → StableTraceCertificateExists` under `[Inhabited X.Trace]`
- proves `StableGenAdmissibleTrace ↔ StableTraceCertificateExists` under `[Inhabited X.Trace]`
- records the empty-trace countermodel to the unconditional reverse implication

Formal dependency:
```lean
[Inhabited X.Trace]
Countermodel:
Generator := Unit
Trace := Empty
StableGen := fun _ => False
In the countermodel:
StableGenAdmissibleTrace holds vacuously
StableTraceCertificateExists fails
Nonempty X.Trace fails
Boundary:
This closes only the inhabited-trace equivalence.
Does not prove:
- unconditional `StableTraceCertificateExists`
- unconditional `StableGenAdmissibleTrace → StableTraceCertificateExists`
- unconditional `StableGenAdmissibleTrace`
- unrestricted `UniversalFiberEntropyGap`
- unrestricted Chronos-RR
- unrestricted H4.1/FGL
- P vs NP
- any Clay problem
