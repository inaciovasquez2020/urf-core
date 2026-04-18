# Spectral Rigidity Bridge

Status: CONDITIONAL

## Closed artifact

The Lean file `scratch/urf/SpectralRigidityBridge.lean` builds.

## Established reduction

The current bridge reduces shell-comparability to the envelope inclusion package:

- `LocalEnvelope`
- `EnvelopeRigidity`
- `spectralRigidity_of_envelopeRigidity`
- `rigidity_persistence_via_envelope`

## Exact remaining theorem-level object

Prove the envelope upper-bound witness

\[
\forall j,k,\quad \operatorname{dist}(j,k)\le C_0 \Longrightarrow E_j \le \operatorname{LocalEnvelope}(k).
\]

together with a repository-native derivation of `EnvelopeRigidity` from the actual flow.

## Stop rule

No unconditional spectral-rigidity conclusion is claimed from this file alone.
