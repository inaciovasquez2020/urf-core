# URF Core Quickstart

This is the shortest path from clone to a first successful local verification pass.

## Requirements

- `git`
- `bash`
- `python3`
- Lean 4 with `lake`
- repository-pinned toolchains as applicable

## 1. Clone

```bash
git clone https://github.com/inaciovasquez2020/urf-core.git
cd urf-core
```

## 2. Check tools

```bash
python3 --version
git --version
lake --version
lean --version
```

## 3. Build

```bash
lake build
```

If your current workflow depends on repository scripts, also run:

```bash
[ -x ./scripts/build.sh ] && ./scripts/build.sh
```

## 4. Verify

```bash
python3 -m pytest -q
[ -x ./scripts/verify.sh ] && ./scripts/verify.sh
```

## 5. Check artifact integrity

Compare the SHA-256 digest of the artifact you obtained with the expected digest in the manifest for that exact release. For example, run `shasum -a 256 path/to/artifact` and compare the complete 64-character digest. The repository’s prefab manifest includes generated outputs and applies to its documented build snapshot.

## 6. Next steps

- detailed environment instructions: `docs/SETUP_GUIDE.md`
- contribution paths: `CONTRIBUTING.md`
- public claims surface: `CLAIMS.md`
