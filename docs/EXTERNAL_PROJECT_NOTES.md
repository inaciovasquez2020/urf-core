## External Project Notes

### Borrowed structural lessons
1. Keep problem-statement files separate from proof files.
2. Keep conditional results explicitly labeled as conditional.
3. Distinguish formalization status from solve-status.
4. Preserve a phase-structured verification roadmap.

### Repository policy
- A formalized statement is not a solved theorem.
- A conditional theorem is not an unconditional closure.
- Public status files must distinguish:
  - statement formalized
  - proof shell present
  - mechanically verified theorem
  - open lemma / blocked frontier

### Integration rule
Future modules should be organized under:
- `FormalStatements/`
- `Proofs/Conditional/`
- `Proofs/Verified/`
- `Status/`

### Reason for inclusion
This note records external structural lessons only.
It does not import claims, proofs, or endorsements from external projects.
