import argparse
import json
import sys
from importlib.resources import files
from pathlib import Path

import jsonschema

DEFAULT_SCHEMA = files("urf_cli.schema") / "urf-sg-v1.0.schema.json"


def cmd_verify(args):
    cert_path = Path(args.cert).resolve()
    schema_path = Path(args.schema).resolve() if args.schema else DEFAULT_SCHEMA

    try:
        cert = json.loads(cert_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(
            f"urf: invalid JSON in {cert_path}: line {exc.lineno}, "
            f"column {exc.colno}: {exc.msg}",
            file=sys.stderr,
        )
        return 2
    except (OSError, UnicodeDecodeError) as exc:
        print(f"urf: cannot read certificate {cert_path}: {exc}", file=sys.stderr)
        return 2

    try:
        schema = json.loads(schema_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(
            f"urf: invalid JSON schema file {schema_path}: line {exc.lineno}, "
            f"column {exc.colno}: {exc.msg}",
            file=sys.stderr,
        )
        return 2
    except (OSError, UnicodeDecodeError) as exc:
        print(f"urf: cannot read schema {schema_path}: {exc}", file=sys.stderr)
        return 2

    try:
        jsonschema.validate(
            cert,
            schema,
            format_checker=jsonschema.FormatChecker(),
        )
    except jsonschema.ValidationError as exc:
        location = ".".join(str(part) for part in exc.absolute_path) or "<root>"
        print(
            f"urf: certificate validation failed at {location}: {exc.message}",
            file=sys.stderr,
        )
        return 1
    except jsonschema.SchemaError as exc:
        print(f"urf: invalid JSON Schema: {exc.message}", file=sys.stderr)
        return 2

    print("VALID")
    return 0


def main():
    parser = argparse.ArgumentParser(
        prog="urf",
        description="Validate a URF-SG certificate against its JSON Schema.",
    )
    subparsers = parser.add_subparsers(dest="cmd", required=True)

    verify = subparsers.add_parser(
        "verify",
        help="validate a certificate's structure and declared field formats",
    )
    verify.add_argument("cert", help="path to the certificate JSON file")
    verify.add_argument(
        "--schema",
        default=None,
        help="optional JSON Schema file (defaults to the bundled URF-SG v1.0 schema)",
    )
    verify.set_defaults(func=cmd_verify)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
