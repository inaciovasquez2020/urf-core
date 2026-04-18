# Envelope Witness Inclusion

Status: OPEN

## Definition

`EnvelopeWitnessInclusion u C0` means:

\[
\forall j,k,\quad \operatorname{dist}(j,k)\le C_0 \Longrightarrow E_j \le \operatorname{LocalEnvelope}(k).
\]

## Role

This packages the auxiliary shell-to-envelope hypothesis from the conditional spectral-rigidity bridge as a named theorem-level object.

## Closure consequence

If both of the following hold:

1. `EnvelopeWitnessInclusion u C0`;
2. `EnvelopeRigidity u C0 A θ`;

then `SpectralRigidity u C0 A θ` follows.

## Stop rule

This file names the missing object; it does not prove it.
