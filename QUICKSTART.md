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

## 5. Reproduce checksums

```bash
sha256sum artifacts/* 2>/dev/null || true
```

## 6. Next steps

- detailed environment instructions: `docs/SETUP_GUIDE.md`
- contribution paths: `CONTRIBUTING.md`
- public claims surface: `CLAIMS.md`
