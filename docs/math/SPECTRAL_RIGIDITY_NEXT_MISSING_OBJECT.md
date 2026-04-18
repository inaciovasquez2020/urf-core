# Spectral Rigidity Next Missing Object

Status: OPEN

## Closed layer

The repository now contains a buildable conditional bridge:

- `scratch/urf/SpectralRigidityBridge.lean`
- `docs/math/SPECTRAL_RIGIDITY_BRIDGE.md`

## Exact next missing object

Prove a repository-native envelope inclusion lemma strong enough to remove the auxiliary hypothesis

\[
\forall j,k,\quad \operatorname{dist}(j,k)\le C_0 \Longrightarrow E_j \le \operatorname{LocalEnvelope}(k).
\]

together with a flow-native derivation of

\[
\operatorname{EnvelopeRigidity}(U_t,C_0,A,\theta).
\]

## Weakest sufficient closure target

A theorem package is sufficient if it proves both:

1. envelope witness inclusion for admissible neighboring shells;
2. envelope rigidity propagated by the actual flow.

## Stop rule

No unconditional spectral-rigidity theorem is claimed until those two ingredients are discharged.
