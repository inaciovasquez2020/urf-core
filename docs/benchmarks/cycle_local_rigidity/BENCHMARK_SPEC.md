# Cycle--Local Rigidity Benchmark Spec

## Fixed Parameters

\[
(k,\Delta,R,N)=(3,4,2,200).
\]

## Benchmark Family

\[
\mathcal B
=
\mathcal B_{\mathrm{tree}}
\sqcup
\mathcal B_{\mathrm{unicyclic}}
\sqcup
\mathcal B_{\mathrm{expander\text{-}like}}
\sqcup
\mathcal B_{\mathrm{gadget}}.
\]

Each instance \(G\) is a finite simple connected graph with:
- \( |V(G)| \le N \)
- \( \max_{v\in V(G)} \deg(v) \le \Delta \)

## Canonical Invariants

For each graph \(G\), define:

\[
\operatorname{TypeCount}_{k,R}(G)
=
\left|
\left\{
\operatorname{tp}_{k,R}(v): v\in V(G)
\right\}
\right|.
\]

\[
C_R(G)
=
\dim_{\mathbf F_2}
\left(
Z_1(G)/Z_1^{\le 2R+1}(G)
\right).
\]

Operationally in benchmark v1:

\[
C_R(G)
=
\dim_{\mathbf F_2}
\left(
\operatorname{span}
\{
[e] :
e\text{ is a non-tree edge whose fundamental cycle has length } > 2R+1
\}
\right).
\]

For the current implementation this equals the number of non-tree edges whose
fundamental cycle length is \(>2R+1\), i.e. the exact rank of the selected
fundamental-cycle subspace.
\]

## Canonical Theorem Target

\[
\boxed{
C_R(G)\ge T_0
\Rightarrow
\operatorname{TypeCount}_{k,R}(G)\ge 2
}
\]

with fixed threshold \(T_0=1\) in benchmark v1.

## Lemma DAG

\[
L_1 \to L_2 \to L_4,\qquad
L_1 \to L_3 \to L_4,\qquad
L_4 \to T.
\]

\[
L_1:
\operatorname{TypeCount}_{k,R}(G) < \infty.
\]

\[
L_2:
C_R(G)\text{ computable from spanning-tree cycle basis.}
\]

\[
L_3:
\operatorname{TypeCount}_{k,R}(G)=1
\Rightarrow
\text{all vertices share one radius-}R\text{ rooted-ball isomorphism type.}
\]

\[
L_4:
\operatorname{TypeCount}_{k,R}(G)=1 \wedge C_R(G)\ge T_0
\Rightarrow \bot
\]

\[
T:
C_R(G)\ge T_0
\Rightarrow
\operatorname{TypeCount}_{k,R}(G)\ge 2.
\]

## Certificate Schema

Each certificate must contain:
- `graph_id`
- `family`
- `n`
- `m`
- `max_degree`
- `k`
- `R`
- `threshold`
- `local_type_count`
- `cycle_overlap_rank`
- `status`
- `witness`

Valid statuses:
- `rigidity_triggered`
- `no_trigger`

For `rigidity_triggered`, witness must include:
- `type_a_vertex`
- `type_b_vertex`

## Verification Contract

\[
\operatorname{verify}(G,\sigma)=\texttt{PASS}
\]

iff:
- graph metadata match
- degree bound holds
- `local_type_count` recomputes correctly
- `cycle_overlap_rank` recomputes correctly
- `status` matches threshold test
- witness vertices exist and have distinct rooted radius-\(R\) types when `rigidity_triggered`

