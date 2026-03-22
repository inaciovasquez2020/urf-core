# Prefab Registry

The prefab registry provides a global lookup mechanism for reusable URF prefab components.

Registry responsibilities

1. Store prefab definitions
2. Prevent duplicate prefab identifiers
3. Provide lookup for URF execution pipelines

Registry interface

register(prefab)
get(name)
list()

The registry enables prefab reuse across URF modules such as:

- urf-core
- urf-verifier
- urf-prefab-system
