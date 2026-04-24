from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs/status/URF_CORE_SURVIVAL_PROTOCOL.md"

REQUIRED = [
    "Status: Core repository-governance protocol",
    "foundational verification and status-control core",
    "solved theorem",
    "closed executable surface",
    "certified frontier",
    "conditional result",
    "open obstruction",
    "`urf-core` must not imply that an open theorem is solved",
    "The durable contribution of `urf-core` is the conversion of hard research structure into auditable, status-normalized, verification-facing artifacts.",
    "Do not expand the core merely by adding new terminology.",
]

def main() -> None:
    if not DOC.exists():
        raise SystemExit("missing docs/status/URF_CORE_SURVIVAL_PROTOCOL.md")
    text = DOC.read_text()
    for needle in REQUIRED:
        if needle not in text:
            raise SystemExit(f"missing required text: {needle}")
    print("urf-core survival protocol verified")

if __name__ == "__main__":
    main()
