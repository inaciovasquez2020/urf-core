URF admissibility mapping for prefab mode

Definitions
Prefab mode system: a typed algebra of compositions with an executable verifier.
Certificate: a JSON object witnessing well-typed composition and admissibility.

Admissibility requirements enforced by this repository
PCA
Prefab Composition Admissibility requires that every composite is typecheckable and certificate-verifiable.

CLR
Cycle-Local Rigidity prohibits asserting perpetual local homogeneity under rich cycle overlap without a local witness.

AKR
Archimedean Kernel Rigidity prohibits persistent global effects without local support under decay.

Checker statement
All ACCEPT decisions are intended to be interpretable as: the input text does not assert a forbidden global claim under CLR or AKR and does not violate prefab composition constraints as represented in the current ruleset.

