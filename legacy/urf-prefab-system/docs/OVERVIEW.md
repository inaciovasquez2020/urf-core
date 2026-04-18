URF Prefab System – Structural Overview
Core object
A prefab is a composable structural unit with:
Explicit assumptions
Declared invariants
Defined attachment interface
Bounded scope of validity
Design intent
Enable assembly of URF components without hidden coupling
Enforce assumption visibility at composition time
Support later formalization and certification
Non-goals
No execution engine
No optimization logic
No global completeness guarantees
Relation to URF
This repository provides structural primitives only.
All semantic strength lives in downstream URF cores.
