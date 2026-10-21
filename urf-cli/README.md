# urf-cli

`urf-cli` provides a command-line check for the structure of a URF-SG v1.0 certificate.

## Install

Requires Python 3.10 or newer.

```bash
python -m pip install urf-cli
```

## Validate a certificate

```bash
urf verify path/to/certificate.json
```

The command uses the URF-SG v1.0 JSON Schema bundled with the package. To supply a different schema explicitly:

```bash
urf verify path/to/certificate.json --schema path/to/schema.json
```

A structurally valid certificate prints `VALID` and exits with status 0. A certificate that does not satisfy the schema exits with status 1. Invalid JSON, unreadable files, or an invalid schema produce a concise diagnostic and exit with status 2.

## What this check establishes

This tool validates JSON structure and declared field formats against a JSON Schema. It does **not** independently prove a mathematical theorem, reproduce a numerical result, recompute artifact SHA-256 digests, or establish that referenced evidence supports the certificate's claim. A `VALID` result means schema validation passed only.

## Development tests

From the `urf-cli` directory, run:

```bash
python -m unittest discover -s tests -v
```

