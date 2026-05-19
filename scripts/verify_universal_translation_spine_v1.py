import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARTIFACT = ROOT / "artifacts/urf/universal_translation_spine_v1_2026_05_19.json"
DOC = ROOT / "docs/status/UNIVERSAL_TRANSLATION_SPINE_V1_2026_05_19.md"

REQUIRED_FIELDS = {
    "domain",
    "encoder",
    "rigidity_grammar_fragment",
    "invariant",
    "frontier_status",
}

REQUIRED_BOUNDARY_TOKENS = [
    "UniversalTranslationTheorem",
    "RigidityGrammar",
    "canonical encoders for all domains",
    "unrestricted `UniversalFiberEntropyGap`",
    "Chronos-RR",
    "H4.1/FGL",
    "P vs NP",
    "any Clay problem",
]

def main() -> None:
    data = json.loads(ARTIFACT.read_text())
    doc = DOC.read_text()

    assert data["id"] == "UNIVERSAL_TRANSLATION_SPINE_V1_2026_05_19"
    assert data["status"] == "STRUCTURAL_UNIFICATION_SURFACE"
    assert data["theorem_promotion"] is False
    assert data["pattern"] == "domain -> encoder -> rigidity_grammar_fragment -> invariant -> frontier_status"
    assert set(data["required_domain_fields"]) == REQUIRED_FIELDS

    seen = set()
    domains = data["domains"]
    assert domains

    for item in domains:
        missing = REQUIRED_FIELDS - set(item)
        assert not missing, f"{item.get('domain', '<unknown>')} missing {sorted(missing)}"
        for field in REQUIRED_FIELDS:
            assert isinstance(item[field], str)
            assert item[field].strip()
        assert item["domain"] not in seen
        seen.add(item["domain"])

    assert "Does not prove:" in doc
    for token in REQUIRED_BOUNDARY_TOKENS:
        assert token in doc

    boundary = data["boundary"]["does_not_prove"]
    assert "P vs NP" in boundary
    assert "any Clay problem" in boundary

    print("Universal Translation Spine v1 artifact verified.")

if __name__ == "__main__":
    main()
