#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LEAN = ROOT / "URFCore/Provenance.lean"
ART = ROOT / "artifacts/urf/provenance_codec_interface_2026_05_26.json"
DOC = ROOT / "docs/status/PROVENANCE_CODEC_INTERFACE_2026_05_26.md"

src = LEAN.read_text(errors="ignore")

for forbidden in [
    r"\baxiom\s+encodeProvenanceProj\b",
    r"\baxiom\s+decodeProvenanceProj\b",
    r"\baxiom\s+encodeSLSADigest\b",
    r"\baxiom\s+decodeSLSADigest\b",
    r"\baxiom\s+decode_encode_prov\b",
    r"\baxiom\s+decode_encode_slsa\b",
]:
    assert not re.search(forbidden, src), forbidden

required_lean = [
    "class ProvenanceCodec where",
    "decode_encode_prov",
    "decode_encode_slsa",
    "theorem slsa_codec_transport [c : ProvenanceCodec]",
    "structure ProvenanceProjDigestEquiv where",
]

for token in required_lean:
    assert token in src, token

data = json.loads(ART.read_text())
assert data["status"] == "PROVENANCE_CODEC_INTERFACE_ONLY_CONDITIONAL"
assert data["replaced_group"] == "provenance_codec"
assert data["replaced_raw_axioms"] == 6
assert data["minimal_missing_lemma_for_concrete_codec"] == "∀ a b, decodePair (encodePair a b) = some (a, b)"

for boundary in [
    "existence of a concrete String pair codec",
    "global URF theorem closure",
    "descent-system obligation resolution",
    "ChronosCert entropy/determinism obligation resolution",
    "transport entropy-set obligation resolution",
    "unrestricted Chronos-RR",
    "unrestricted H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]:
    assert boundary in data["does_not_prove"], boundary

doc = DOC.read_text(errors="ignore")
assert "PROVENANCE_CODEC_INTERFACE_ONLY_CONDITIONAL" in doc
assert "Does not prove" in doc
assert "any Clay problem" in doc

print("PROVENANCE_CODEC_INTERFACE_OK")
print(json.dumps(data, indent=2, sort_keys=True))
