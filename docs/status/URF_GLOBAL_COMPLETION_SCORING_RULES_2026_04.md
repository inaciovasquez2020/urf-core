# URF Global Completion Scoring Rules (v1)

## Status
CANONICAL

## Scope
This file declares the scoring rules used by
`docs/status/URF_GLOBAL_COMPLETION_MODEL_V1_2026_04.json`.

## Rules
### `status_complete_or_proved_ratio`
For the designated module surface, define
\[
c(M)=\frac{\#\{\text{declared target files with terminal status COMPLETE or PROVED}\}}{\#\{\text{declared target files}\}}.
\]

### `verified_surface_ratio`
For the designated module surface, define
\[
c(M)=\frac{\#\{\text{designated executable checks currently passing}\}}{\#\{\text{designated executable checks}\}}.
\]

### `passing_integrity_checks_ratio`
For the designated integrity surface, define
\[
c(M)=\frac{\#\{\text{designated CI or repository-integrity checks currently passing}\}}{\#\{\text{designated CI or repository-integrity checks}\}}.
\]

### `current_instance_closure_ratio`
For the designated community surface, define
\[
c(M)=\frac{\#\{\text{declared current-instance certificate targets with status PROVED}\}}{\#\{\text{declared current-instance certificate targets}\}}.
\]

### `audit_truth_surface_ratio`
For the designated audit surface, define
\[
c(M)=\frac{\#\{\text{declared audit or truth surfaces passing their repository-native checks}\}}{\#\{\text{declared audit or truth surfaces}\}}.
\]

### `policy_declared_and_tested`
Define
\[
c(M)=1
\]
iff the canonical model file exists, this scoring-rule file exists, and the repository-native policy test passes.
Otherwise define
\[
c(M)=0.
\]

## Consequence
Given a fixed module set and fixed weights, each module score
\[
c(M)\in[0,1]
\]
is determined by repository-native rules fixed in advance.

## Versioning rule
Any change to the module set, module weights, or scoring rules creates a new versioned global completion model.
