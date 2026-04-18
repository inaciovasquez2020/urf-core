# Envelope Witness Inclusion Frontier

Status: OPEN

## Object

Prove the shell-to-envelope inclusion statement
\[
\forall j,k,\quad \operatorname{dist}(j,k)\le C_0 \Longrightarrow E_j \le \operatorname{LocalEnvelope}(k).
\]

## Role

This is the first theorem-level ingredient in the spectral-rigidity closure package.

## Closure consequence

Together with envelope-rigidity propagation, this is sufficient for
\[
\operatorname{SpectralRigidity}(u,C_0,A,\theta).
\]

## Stop rule

This file isolates the frontier; it does not prove it.
