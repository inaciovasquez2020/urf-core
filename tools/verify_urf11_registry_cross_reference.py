from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs/status/URF11_TRANSLATION_SUBPROBLEM_REGISTRY_CROSS_REFERENCE_2026_05_10.md"

REQUIRED = [
    "URF11_REGISTRY_ONLY",
    "https://github.com/inaciovasquez2020/urf-11-translation-subproblem-registry",
    "22a8e88",
    "ed3e5b9",
    "aeda665",
    "636d4df",
    "No unrestricted Chronos-RR closure.",
    "No H4.1/FGL closure.",
    "No UniversalFiberEntropyGap theorem.",
    "No P vs NP.",
    "No Clay-problem closure.",
    "No unrestricted graph-rigidity theorem.",
    "No unrestricted Cayley-graph rigidity theorem.",
]

FORBIDDEN = [
    "unrestricted Chronos-RR closure.",
    "H4.1/FGL closure.",
    "UniversalFiberEntropyGap theorem.",
    "P vs NP.",
    "Clay-problem closure.",
    "unrestricted graph-rigidity theorem.",
    "unrestricted Cayley-graph rigidity theorem.",
]

def main() -> None:
    text = DOC.read_text()

    for token in REQUIRED:
        assert token in text, token

    for token in FORBIDDEN:
        assert f"No {token}" in text, token

if __name__ == "__main__":
    main()
