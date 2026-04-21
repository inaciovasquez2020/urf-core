# URF-11 Current-Instance Registry Closure Certificate

## Status
OPEN

## Certified current-instance statement
For the current registries on this repository state, every declared bridge packet resolves through all canonical registry layers:
\[
(\texttt{source\_field},\texttt{source\_subproblem})
\in \texttt{SUBPROBLEM\_REGISTRY},
\]
\[
(\texttt{source\_field},\texttt{target\_field},\texttt{exported\_object})
\in \texttt{EXPORTED\_OBJECT\_REGISTRY},
\]
\[
(\texttt{source\_field},\texttt{target\_field},\texttt{translation\_rule})
\in \texttt{TRANSLATION\_RULE\_REGISTRY},
\]
\[
\texttt{acceptance\_id}=\texttt{ACCEPTANCE\_REGISTRY}(\texttt{target\_field}),
\qquad
\texttt{benchmark}\in \texttt{BENCHMARK\_REGISTRY},
\]
and each packet has a declared witness and PASS benchmark result:
\[
(\texttt{bridge\_id},\texttt{benchmark},\texttt{acceptance\_id},\texttt{witness\_type})
\in \texttt{PROMOTION\_WITNESS\_REGISTRY},
\]
\[
(\texttt{bridge\_id},\texttt{benchmark},\texttt{metric},\texttt{status}=	exttt{PASS})
\in \texttt{BENCHMARK\_RESULT\_REGISTRY}.
\]

Plain form:
Every current bridge packet closes through the subproblem, object, rule, acceptance, benchmark, witness, and result registries.

## Computed witness source
- `docs/community/urf11/BRIDGE_PACKET_REGISTRY.yaml`
- `docs/community/urf11/SUBPROBLEM_REGISTRY.yaml`
- `docs/community/urf11/EXPORTED_OBJECT_REGISTRY.yaml`
- `docs/community/urf11/TRANSLATION_RULE_REGISTRY.yaml`
- `docs/community/urf11/ACCEPTANCE_REGISTRY.yaml`
- `docs/community/urf11/BENCHMARK_REGISTRY.yaml`
- `docs/community/urf11/PROMOTION_WITNESS_REGISTRY.yaml`
- `docs/community/urf11/BENCHMARK_RESULT_REGISTRY.yaml`
- `tests/test_urf11_registry_closure_certificate.py`

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify registry closure for every current bridge packet.
