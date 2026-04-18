Validation Rules
Document-level validation
STATUS.md must list proven, conditional, and open items
ASSUMPTIONS.md is the single source of truth for assumption IDs
PREFAB_INDEX.md must list every example prefab
Schema-level validation
JSON prefabs must conform to schema/prefab.schema.json
No additional properties beyond the schema are allowed
All assumption IDs used must appear in ASSUMPTIONS.md
CI behavior
Validation is structural only
No semantic or execution validation is performed
Missing optional tools must not fail CI
Failure policy
Structural violations fail CI
Missing optional validators emit warnings only
