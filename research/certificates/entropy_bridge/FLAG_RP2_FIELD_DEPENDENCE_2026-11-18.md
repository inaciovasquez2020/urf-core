# Flag projective-plane witness: field-dependent hidden entropy

Date: 2026-11-18
Status: **EXACT FINITE COMPUTATION_PASS**, mathematical derivation;
**LEAN_VERIFICATION := NOT_RUN**.
Published base `a06477e82e96e90c316611c6bf71073e70297d62`
and local Mac files were not modified.

## Construction

Start from six vertices 0,...,5 and the ten triangular facets:

```
012 013 024 035 045
125 134 145 234 235
```

Every one of the 15 edges lies in exactly two facets and each vertex
link is a 5-cycle. There are 6 vertices, 15 edges, 10 faces, hence
Euler characteristic 6−15+10=1. This is a closed connected combinatorial
surface homeomorphic to the real projective plane RP².

Let G be the comparability graph of all nonempty simplicial faces
(6 vertices, 15 edges, 10 triangles = 31 vertices total):
two face-poset elements are adjacent exactly when one is a proper
subset of the other. Its clique complex is precisely the
barycentric subdivision of the original RP² triangulation.
Consequently G is an ordinary finite SIMPLE graph, and its clique
complex is a flag triangulation of RP².

## Exact matrix audit

For the 31-vertex G, the graph contains 90 edges and 60 triangular
cliques (2-simplices). With integer oriented boundary matrices
∂1 (31×90) and ∂2 (90×60), the script proves ∂1∂2=0 modulo
each tested prime by testing every entry, and computes:

| K | rank ∂1 | rank ∂2 | β1=90−rank∂1−rank∂2 |
|---|---:|---:|---:|
| F2 | 30 | 59 | 1 |
| F3 | 30 | 60 | 0 |
| F5 | 30 | 60 | 0 |

An independent implementation separately computed exactly the
same incidence ranks in this research session. The committed
reproducible script is
`check_flag_rp2_field_dependence.py`, standard-library only.

For fields of characteristic two, RP² has nonzero H1; for odd
characteristics it has zero H1. This standard homological fact also
follows from H1(RP²; Z)=Z/2 and the universal coefficient theorem.
The finite matrix checks certify the explicit construction over the
three enumerated finite fields, not all possible fields.

## Consequence for the entropy bridge

As shown mathematically (but NOT yet in Lean) for radius-one
observation, `ker Obs_R1 ≃ (H1(clique G;K))*`, hence its
dimension is `β1(clique G;K)`.

The sharp uniform-input capacity is therefore field-dependent:

* Over F2: maximum hidden conditional entropy = `log 2`.
* Over F3 or F5: the observation kernel is zero, and hidden
  conditional entropy = 0 for every input distribution.

More generally the characteristic matters: arbitrary-field
first homology should NOT be assumed independent of K.

This witness prevents any proposed global lemma claiming that
`β1(clique G;K)`, the radius-one hidden dimension, or the
corresponding entropy capacity is coefficient-field independent.

It does not refute the existing field-indexed entropy theorem;
rather, it verifies why `K` must remain explicit in every statement.

## Verification boundary

* Exact finite matrix check: COMPUTATION_PASS.
* Identification of face-poset clique complex with barycentric RP²:
  mathematically established from construction, Lean OPEN.
* `R1 = im ∂2`: mathematical proof, Lean OPEN.
* `ker Obs ≃ H1*`: mathematical proof, Lean OPEN.
* Uniform-input conditional equality: Lean OPEN.
* New GitHub HEAD build: NOT_RUN.
* No merge, no local Mac changes.
