# Capacity Soundness Reduction

Status: `CONDITIONAL`

Closed objects:
- `Trace`
- `Adm`
- `Encodes`
- `C_adm`
- `AdmissibleTraceBound`
- `CapacitySoundness`
- `capacity_obstruction_contrapositive`

Unique open object:
- `StableGenAdmissibleTrace`

Conditional theorem:
```lean
StableGenAdmissibleTrace X →
CapacitySoundness X
Contrapositive obstruction:
C_adm X < X.I g →
¬ X.StableGen g
Boundary:
This reduces CapacitySoundness to StableGenAdmissibleTrace.
Does not prove:
- `StableGenAdmissibleTrace`
- unrestricted `UniversalFiberEntropyGap`
- unrestricted Chronos-RR
- unrestricted H4.1/FGL
- P vs NP
- any Clay problem
