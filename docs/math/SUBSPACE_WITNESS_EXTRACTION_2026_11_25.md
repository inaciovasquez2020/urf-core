# Independent witnesses in sums of subspaces

PROVED_ON_PAPER; LEAN_NOT_RUN; novelty not established.

For a finite indexed family of finite-dimensional subspaces U_i of a common vector space over a field K, let d=dim(sum_i U_i). Choose a basis of each U_i, extract a basis of the sum from their union, and assign each selected vector to one supporting index. Each used index receives at most dim U_i independent vectors. Thus d <= sum_{i in J} dim U_i for the set J of used indices. Retaining one vector per used index gives independent vectors with distinct supporting indices. For D=max_i dim U_i>0 this gives at least ceil(d/D) witnesses. More sharply, if d_1>=...>=d_n are the sorted dimensions, the number of witnesses is at least the least m with sum_{j=1}^m d_j>=d. If d=0 the empty family suffices. The uniform bound is sharp for a direct sum of m D-dimensional subspaces.

For graph cycle spaces use their embeddings in the common edge space, not abstract isomorphism types. K5 radius-one balls each have cycle rank 6 but there are only 5 centers, so a basis with distinct centers need not exist.

Formalization target: finite indexed Submodule family, independent vectors with injective supporting-index map and the cardinal bound. Inspect existing mathlib independent transversal and basis extraction results first. Lean 4.27.0 at inspected revision. No Lean declarations changed; build and axiom audit NOT_RUN.
