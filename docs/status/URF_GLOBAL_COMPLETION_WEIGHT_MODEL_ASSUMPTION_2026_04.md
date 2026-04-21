# URF Global Completion Weight Model Assumption

## Status
ASSUMED

## Weakest sufficient missing assumption
There exists a fixed finite canonical module set
\[
\mathcal{M}_{\mathrm{URF}}
\]
and a fixed weight map
\[
w:\mathcal{M}_{\mathrm{URF}}\to [0,1]
\]
such that
\[
\sum_{M\in\mathcal{M}_{\mathrm{URF}}} w(M)=1.
\]

For each module \(M\in\mathcal{M}_{\mathrm{URF}}\), there exists a fixed completion score
\[
c(M)\in[0,1]
\]
determined only by repository-native criteria fixed in advance.

The global URF completion percentage is defined by
\[
P_{\mathrm{URF}}:=100\sum_{M\in\mathcal{M}_{\mathrm{URF}}} w(M)c(M).
\]

## Minimal admissibility conditions
1. \(\mathcal{M}_{\mathrm{URF}}\) is fixed before percentage computation.
2. \(w\) is fixed before percentage computation.
3. \(c(M)\) depends only on predeclared repository-native status rules for \(M\).
4. No module weight depends on the computed value of \(P_{\mathrm{URF}}\).
5. Any later change to \(\mathcal{M}_{\mathrm{URF}}\), \(w\), or the scoring rule for some \(M\) creates a new versioned model.

## Consequence
Under this assumption, any quoted global percentage
\[
P_{\mathrm{URF}}
\]
is well-defined and reproducible.

## Finish condition
Replace `ASSUMED` by `PROVED-AS-POLICY` only after the canonical module list, canonical weights, and module scoring rules are declared repository-natively.
