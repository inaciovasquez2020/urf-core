structure ProvenanceProj where
  leanDepsHash : String
  buildMerkleRoot : String

structure SLSADigest where
  lean_deps_hash : String
  build_merkle_root : String

def projToDigest (p : ProvenanceProj) : SLSADigest :=
  ⟨p.leanDepsHash, p.buildMerkleRoot⟩

def digestToProj (d : SLSADigest) : ProvenanceProj :=
  ⟨d.lean_deps_hash, d.build_merkle_root⟩

theorem proj_digest_left_inv : ∀ p, digestToProj (projToDigest p) = p := by
  intro p
  cases p
  rfl

theorem proj_digest_right_inv : ∀ d, projToDigest (digestToProj d) = d := by
  intro d
  cases d
  rfl

structure ProvenanceProjDigestEquiv where
  toFun : ProvenanceProj → SLSADigest
  invFun : SLSADigest → ProvenanceProj
  left_inv : ∀ p, invFun (toFun p) = p
  right_inv : ∀ d, toFun (invFun d) = d

def projDigestEquiv : ProvenanceProjDigestEquiv where
  toFun := projToDigest
  invFun := digestToProj
  left_inv := proj_digest_left_inv
  right_inv := proj_digest_right_inv

namespace URFCore

-- Conditional: assume a canonical JSON codec for each record.
-- Conditional codec interface. This packages the external JSON/string codec
-- obligation as explicit typeclass data rather than global axioms.
class ProvenanceCodec where
  encodeProvenanceProj : ProvenanceProj → String
  decodeProvenanceProj : String → Option ProvenanceProj
  encodeSLSADigest : SLSADigest → String
  decodeSLSADigest : String → Option SLSADigest
  decode_encode_prov : ∀ p, decodeProvenanceProj (encodeProvenanceProj p) = some p
  decode_encode_slsa : ∀ d, decodeSLSADigest (encodeSLSADigest d) = some d

def encodeProvenanceProj [c : ProvenanceCodec] : ProvenanceProj → String :=
  c.encodeProvenanceProj

def decodeProvenanceProj [c : ProvenanceCodec] : String → Option ProvenanceProj :=
  c.decodeProvenanceProj

def encodeSLSADigest [c : ProvenanceCodec] : SLSADigest → String :=
  c.encodeSLSADigest

def decodeSLSADigest [c : ProvenanceCodec] : String → Option SLSADigest :=
  c.decodeSLSADigest

theorem decode_encode_prov [c : ProvenanceCodec] :
    ∀ p, c.decodeProvenanceProj (c.encodeProvenanceProj p) = some p :=
  c.decode_encode_prov

theorem decode_encode_slsa [c : ProvenanceCodec] :
    ∀ d, c.decodeSLSADigest (c.encodeSLSADigest d) = some d :=
  c.decode_encode_slsa

theorem slsa_codec_transport [c : ProvenanceCodec] (p : ProvenanceProj) :
    c.decodeSLSADigest (c.encodeSLSADigest (projToDigest p)) = some (projToDigest p) := by
  simpa using (c.decode_encode_slsa (projToDigest p))

end URFCore
