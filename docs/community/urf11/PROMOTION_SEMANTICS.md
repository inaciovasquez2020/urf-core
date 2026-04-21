# URF-11 Promotion Semantics

## Status
PROVED

## Definition
\[
\operatorname{Promote}(\Pi_{i\to j}) = 1
\iff
\exists w \in \texttt{PROMOTION\_WITNESS\_REGISTRY},\
\exists r \in \texttt{BENCHMARK\_RESULT\_REGISTRY}
\]
such that
\[
w.\texttt{bridge\_id}=\Pi_{i\to j}.\texttt{bridge\_id},
\qquad
w.\texttt{benchmark}=\Pi_{i\to j}.\texttt{benchmark},
\qquad
w.\texttt{acceptance\_id}=\Pi_{i\to j}.\texttt{acceptance\_id},
\]
and
\[
r.\texttt{bridge\_id}=\Pi_{i\to j}.\texttt{bridge\_id},
\qquad
r.\texttt{benchmark}=\Pi_{i\to j}.\texttt{benchmark},
\qquad
r.\texttt{status}=\texttt{PASS}.
\]

Plain form:
Promote(Pi_{i->j}) = 1 iff there exists a declared witness record matching the bridge packet and there exists a declared benchmark result record with status PASS for the same bridge_id and benchmark.

## Record field
`benchmark_status` denotes the status field on the declared benchmark result record.

## Consequence
\[
\operatorname{Promote}(\Pi_{i\to j}) = 1
\Longrightarrow
\texttt{benchmark\_status}=\texttt{PASS}.
\]

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify witness completeness, PASS-linked promotion semantics, and nonescape of all promotion-managed paths.
