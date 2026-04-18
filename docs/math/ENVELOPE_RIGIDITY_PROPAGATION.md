# Envelope Rigidity Propagation

Status: OPEN

## Exact object

Prove a flow-native theorem of the form

\[
\forall t \in [0,T],\qquad \operatorname{EnvelopeRigidity}(U_t,C_0,A,\theta).
\]

## Role

This is the second half of the weakest sufficient closure package for unconditional spectral rigidity.

## Closure consequence

If both of the following hold:

1. `EnvelopeWitnessInclusion u C0`;
2. `EnvelopeRigidity u C0 A θ`;

then `SpectralRigidity u C0 A θ` follows.

## Stop rule

This file names the missing propagation object; it does not prove it.
