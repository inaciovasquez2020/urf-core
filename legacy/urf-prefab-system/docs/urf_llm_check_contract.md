urf-llm-check contract

Interface
stdin: UTF-8 text
stdout: one line verdict
  ACCEPT
  REJECT

Optional diagnostics
If diagnostics are enabled by flags, they must be emitted to stderr only and must be JSON lines, one object per line.

Determinism
Given identical input text and identical tool version, verdict is deterministic.

Admissibility alignment
Locality
Verdict must depend only on locally extractable structure from the input text, as defined by the checker ruleset version.

Capacity
The checker must not incorporate external retrieval or hidden global state.

No oracles
No network access, no model calls, no hidden caches beyond local deterministic rule tables.

