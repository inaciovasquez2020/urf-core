# Contributing to URF Core

URF Core is the semantic authority of the URF ecosystem.

## Contribution classes

### 1. Documentation improvements

Examples:

- clarify README language
- expand setup instructions
- improve quickstart commands
- fix broken links or ambiguous wording
- add worked examples for repository navigation

### 2. Proof refactors without semantic change

Examples:

- improve readability
- reduce duplication
- reorganize proof structure
- add comments and local clarifications

### 3. Test and verification hardening

Examples:

- strengthen truth tests
- add regression tests
- improve verification scripts
- surface repository invariants more clearly

### 4. Foundational or semantic changes

These require explicit justification.

Examples:

- changing definitions
- changing certificate semantics
- weakening or removing invariants
- expanding foundational claim scope

## Rules

- All new invariants must be documented and schema-representable.
- Changes to axioms or certificate semantics require explicit justification.
- CI must remain green.

## Allowed

- documentation improvements
- proof refactors without semantic change
- toolchain maintenance
- test hardening
- verification-surface improvements

## Disallowed without explicit justification

- silent semantic changes
- removing or weakening invariants
- expanding claims without updating the public claim surface
- mixing unrelated changes into one PR

## Preferred workflow

```bash
git fetch origin --prune
git switch main
git pull --ff-only origin main
git switch -c your-branch-name
```

Make the smallest relevant change first, then run:

```bash
lake build
python3 -m pytest -q
```

Then commit:

```bash
git add <files>
git commit -m "docs: improve onboarding surface"
git push -u origin your-branch-name
```

## Pull request expectations

A good PR should include:

- a clear title
- what changed
- why it changed
- commands used for verification
- whether the change is semantic or non-semantic

## High-value starter tasks

- improve onboarding wording
- tighten first-run commands
- add missing examples
- fix public-surface mismatches
- strengthen status and repository-map documentation
