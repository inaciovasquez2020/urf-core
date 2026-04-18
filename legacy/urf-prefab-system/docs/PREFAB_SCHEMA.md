Prefab Schema (Draft)
Required fields
id: stable identifier
assumptions: list of assumption IDs
invariants: list of invariant statements
interface.inputs: declared dependencies
interface.outputs: declared artifacts
scope: explicit non-goals
Optional fields
references: external repos or papers
formalization: Lean or other proof hooks
certification: URF-SG compatibility notes
Validation rules
All assumptions must appear in ASSUMPTIONS.md
No invariant may exceed declared scope
No undeclared dependency allowed
Status
Draft schema, non-normative
