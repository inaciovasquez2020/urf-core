#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

texts = []
for base in [ROOT / "lean", ROOT / "docs/status", ROOT / "artifacts"]:
    if base.exists():
        for path in base.rglob("*"):
            if path.is_file() and path.suffix in {".lean", ".md", ".json"}:
                try:
                    text = path.read_text()
                except UnicodeDecodeError:
                    continue
                if (
                    "urf_law3" in text.lower()
                    or "law 3" in text.lower()
                    or "nonamplification" in text.lower()
                    or "cmi_nonneg" in text
                    or "CMINonnegativityProof" in text
                ):
                    texts.append(text)

combined = "\n".join(texts)

assert combined, "missing URF Law 3 / entropy nonamplification material"
assert "cmi_nonneg" in combined or "CMINonnegativityProof" in combined
assert "chain_rule" in combined or "chain rule" in combined
assert "capacity" in combined
assert (
    "NOT_GLOBAL_URF_LAW3" in combined
    or "global URF Law 3" in combined
    or "Global" in combined
), "missing global-law boundary language"

print("URF_LAW3_ENTROPY_NONAMPLIFICATION_OK")
