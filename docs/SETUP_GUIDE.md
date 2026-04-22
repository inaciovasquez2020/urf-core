# Setup Guide

This guide is for contributors who want a reliable local environment for URF Core.

## Supported work classes

- documentation and status updates
- Python-side verification and truth tests
- Lean formalization maintenance
- repository hardening and contributor-surface improvements

## Core prerequisites

Check these first:

```bash
python3 --version
git --version
lake --version
lean --version
```

Recommended baseline:

- Python 3.10 or newer
- Git
- Lean 4 with `lake`
- POSIX shell environment

## Clone

```bash
git clone https://github.com/inaciovasquez2020/urf-core.git
cd urf-core
```

## Optional Python virtual environment

```bash
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install --upgrade pip
```

## Python test tooling

```bash
python3 -m pip install pytest
```

## Lean build

```bash
lake build
```

## Python verification pass

```bash
python3 -m pytest -q
```

## Combined first pass

```bash
lake build && python3 -m pytest -q
```

## Optional TeX tooling

```bash
pdflatex --version
```

TeX is not required for every contribution type.

## Recommended edit loop

```bash
git pull --ff-only origin main
lake build
python3 -m pytest -q
git status --short
```

## Troubleshooting

### `lake: command not found`

Install Lean 4 and ensure `lake` is on `PATH`.

### `lean: command not found`

Install Lean 4 and reload your shell.

### `No module named pytest`

Install pytest into the active Python environment:

```bash
python3 -m pip install pytest
```

## Related files

- `QUICKSTART.md`
- `CONTRIBUTING.md`
- `CLAIMS.md`
