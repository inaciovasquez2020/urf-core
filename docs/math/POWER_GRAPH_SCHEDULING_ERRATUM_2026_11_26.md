# Power graph scheduling versus entropy depth

PROVED_ON_PAPER; LEAN_NOT_RUN; novelty not established.

## Exact scheduling theorem

Let G be a nonempty finite simple graph and R a nonnegative integer. Define G^(2R) by adjacency of distinct vertices at distance at most 2R. In the pure covering model, any independent set of this graph may be activated in one round, and the only objective is to activate every vertex at least once. The minimum number of rounds T_cover equals chi(G^(2R)): assign each vertex its first activation round to obtain a proper coloring; conversely activate the color classes of a proper coloring. In a more restrictive computational model with the same conflict and coverage requirements, only T >= chi follows unless every such schedule is executable and sufficient.

For maximum degree Delta>=2, greedy coloring gives chi <= 1+Delta sum_{i=0}^{2R-1}(Delta-1)^i. The cases Delta=0,1 have chi<=2 (and R=0 gives chi=1). This gives bounded pure scheduling depth at fixed Delta,R, not bounded arbitrary computational depth.

For connected G on n vertices, chi=n iff the power graph is complete iff diam(G)<=2R: a missing edge permits coloring its endpoints alike using n-1 colors. Logarithmic R and logarithmic diameter do not guarantee the inequality. For example take the complete binary tree of height h, n=2^(h+1)-1, maximum degree three, diameter 2h, and R=floor(log2(n)/4). Then chi<=3*2^(2R)-2<=3 sqrt(n), although R=Theta(log n) and diameter=Theta(log n). The same upper bound applies to degree-three expander families at this radius. A sufficiently large constant multiplying log n relative to the actual diameter bound is required.

Linear chi does not imply complete power graph: attach a path of m new vertices to a vertex of K_m, m>=3. With n=2m and R=1, chi(G^2)>=m while diam(G)=m+1. This example has unbounded degree. No unrestricted necessity claim follows. The purported three regimes overlap (large logarithmic radius on small-diameter graphs satisfies two) and are not exhaustive (paths with growing intermediate radius). They are separate sufficient estimates.

## Information depth

For finite random X, nested transcripts S_0,...,S_T, positive c, and active sets A_t independent in G^(2R), suppose the actual aggregate conditional mutual information satisfies I(X;S_{t+1}|S_t)<=c alpha(G^(2R)) at every round. A sufficient alternative is a conditional gain cap c per revealed active-vertex observation, with a justified chain-rule decomposition and at most alpha observations per round. Then telescope:
H(X|S_0)-H(X|S_T)<=Tc alpha(G^(2R)).
With coverage, T>=max{chi(G^(2R)),[H(X|S_0)-H(X|S_T)]/[c alpha(G^(2R))]}. Input-independent initialization and full terminal recovery are needed to recover the historical H(X) numerator. Activating every vertex with constant output is a counterexample to the original inference: arbitrary independent random input can be left entirely unrecovered. Marginal per-vertex information caps alone need not imply conditional aggregate caps (synergy). No unrestricted complexity lower bound follows.

## Source scope

The ten source files listed below form the audited power-graph cluster (including the module entry point). The valid degree and diameter graph theorems are retained. The master theorem is interpreted under explicit exclusion and coverage assumptions, not arbitrary locality. Historical claims beyond the proved scope are superseded by this erratum; original TeX blobs are preserved to avoid breaking frozen-source checks. No existing Lean declarations, published PDFs or historical receipts changed.

- manuscripts/metric_collapse_entropy/Metric_Collapse_Entropy_Depth.tex (blob 92e62802ddd4821c255c4dd62568cf67ace56b22)
- manuscripts/power_graph/Bounded_ChiR_Theorem.tex (blob bede022b7afdf880c8250fad5734768a6da952ca)
- manuscripts/power_graph/Chronos_Integration.tex (blob 29b86306656c0369ea7837255441d7719f97beb5)
- manuscripts/power_graph/Diameter_Collapse_Theorem.tex (blob b24c07e32f6d5b1f80fe2701978adf7c42d51272)
- manuscripts/power_graph/Locality_Diameter_Entropy_Dichotomy.tex (blob 143ca01fef6aaf6282c85a93b57e111d5c91bfd7)
- manuscripts/power_graph/Logarithmic_R_Regime.tex (blob 43d9901b3323ea72037e01a1b93be9e70034ccf0)
- manuscripts/power_graph/Power_Graph_Master_Theorem.tex (blob cff61b5750ed86d0605ff6af7ea908cf5926527b)
- manuscripts/power_graph/Power_Graph_Module.tex (blob ce3e516c9e947ee9e7abef89800bcf2bbc73f275)
- manuscripts/power_graph/Structural_Dichotomy.tex (blob 476418dbfe451d6b3fcb4a6fd4cd6cb86b381aa9)
- papers/local-depth-bound/Power_Graph_Depth_Bound.tex (blob 40d7ec90d244e4d2eef9ba4468602a3738c53cd3)
