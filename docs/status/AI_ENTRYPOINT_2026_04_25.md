# AI Entrypoint — urf-core

Status: CANONICAL AI ENTRYPOINT.

This file exists so that AI agents can use the repository safely without reading only the README.

## Repository

`urf-core`

## Current certified scope

Current certified scope:
- URF core repository-governance and status-control surface
- survival protocol / no-overclaim boundary where present
- executable repository checks where present

Does not claim:
- universal completion of every URF theorem-layer obligation
- closure of external Clay-level mathematical problems
- completion beyond explicitly certified repository surfaces

Canonical verification:
python3 -m pytest -q
lake build

## Safe one-line summary

This repository should be interpreted through its executable/status surface and explicit claim-boundary files. It should not be summarized as full theorem-layer completion unless that exact claim is explicitly certified.

## Machine-readable status

```json
{
  "repository": "urf-core",
  "ai_entrypoint": true,
  "full_theorem_layer_complete": false,
  "general_problem_complete": false,
  "claim_boundary_required": true,
  "canonical_files": [
    "AGENTS.md",
    "README.md",
    "docs/status/"
  ]
}
```
