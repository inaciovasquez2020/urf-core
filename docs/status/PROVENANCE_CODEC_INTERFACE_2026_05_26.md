# Provenance Codec Interface — 2026-05-26

Status: `PROVENANCE_CODEC_INTERFACE_ONLY_CONDITIONAL`

This replaces the raw provenance-codec axiom group with an explicit `ProvenanceCodec` interface.

Minimal missing lemma for a concrete codec:

```lean
∀ a b, decodePair (encodePair a b) = some (a, b)
Does not prove:
existence of a concrete String pair codec
global URF theorem closure
descent-system obligation resolution
ChronosCert entropy/determinism obligation resolution
transport entropy-set obligation resolution
unrestricted Chronos-RR
unrestricted H4.1/FGL
P vs NP
any Clay problem
