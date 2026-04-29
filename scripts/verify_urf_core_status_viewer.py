#!/usr/bin/env python3
from __future__ import annotations

import html as _html
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable

REPO_NAME = "urf-core"
ARTIFACT_TYPE = "urf core axiom artifact"
STATUS_PAGE = Path("docs/status/URF_CORE_STATUS_VIEWER.html")

REQUIRED_TEXT = (
    REPO_NAME,
    ARTIFACT_TYPE,
    "does not prove theorem-complete urf closure",
    "does not prove any millennium-level result",
    "does not certify external mathematics",
    "does not certify a physical or engineering system",
    "does not claim proof-complete formalization",
    "claim flags",
    "artifact metadata",
    "closed surfaces",
    "open surfaces",
    "conditional surfaces",
    "certification map",
    "status interpretation",
)

REQUIRED_CSS = (
    "surf closed",
    "surf open",
    "surf cond",
    "tag closed",
    "tag open",
    "tag cond",
)

FORBIDDEN_POSITIVE = (
    "proves theorem-complete urf closure",
    "theorem-complete urf closure is complete",
    "proves a millennium-level result",
    "proves any millennium-level result",
    "certifies external mathematics",
    "certifies a physical system",
    "certifies an engineering system",
    "physical certification is complete",
    "engineering certification is complete",
    "proof-complete formalization is complete",
    "theorem-complete proof",
)

@dataclass
class Report:
    ok: bool = True
    failures: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)

    def fail(self, msg: str) -> None:
        self.ok = False
        self.failures.append(msg)

    def note(self, msg: str) -> None:
        self.notes.append(msg)


_TAG_RE = re.compile(r"<[^>]+>")
_WS_RE = re.compile(r"\s+")


def strip_html(raw: str) -> str:
    raw = re.sub(r"<script\b[^>]*>.*?</script>", " ", raw, flags=re.I | re.S)
    raw = re.sub(r"<style\b[^>]*>.*?</style>", " ", raw, flags=re.I | re.S)
    text = _TAG_RE.sub(" ", raw)
    text = _html.unescape(text)
    return _WS_RE.sub(" ", text).strip()


def is_safe_for_phrase(sentence: str, phrase: str) -> bool:
    lower = sentence.lower()
    if phrase == "theorem-complete proof":
        return "no theorem-complete proof" in lower or "not a theorem-complete proof" in lower
    return False


def check_forbidden_claims(visible: str, report: Report) -> None:
    lower = visible.lower()
    for phrase in FORBIDDEN_POSITIVE:
        start = 0
        while True:
            idx = lower.find(phrase, start)
            if idx < 0:
                break
            sentence = visible[max(0, idx - 120): idx + len(phrase) + 120]
            if not is_safe_for_phrase(sentence, phrase):
                report.fail(
                    "forbidden positive claim outside negation: "
                    f"{phrase!r} near: {sentence[:240]!r}"
                )
            start = idx + len(phrase)


def run(path: Path = STATUS_PAGE) -> Report:
    report = Report()

    if not path.exists():
        report.fail(f"missing status page: {path}")
        return report

    raw = path.read_text(encoding="utf-8")
    raw_lower = raw.lower()

    if len(raw.strip()) < 500 or "<html" not in raw_lower:
        report.fail("status page is not nontrivial HTML")
        return report

    report.note(f"status page found ({len(raw)} bytes)")

    visible = strip_html(raw)
    lower = visible.lower()

    for item in REQUIRED_TEXT:
        if item.lower() not in lower:
            report.fail(f"required text missing: {item}")

    for item in REQUIRED_CSS:
        if item not in raw_lower:
            report.fail(f"required CSS marker missing: {item}")

    check_forbidden_claims(visible, report)
    return report


def format_report(report: Report) -> str:
    lines = ["urf-core :: status-viewer verifier", "=" * 42]
    lines.extend(f"  · {note}" for note in report.notes)
    if report.ok:
        lines.append("RESULT: PASS")
    else:
        lines.append("RESULT: FAIL")
        lines.extend(f"  ✗ {failure}" for failure in report.failures)
    return "\n".join(lines)


def main(argv: Iterable[str]) -> int:
    args = list(argv)
    path = Path(args[0]) if args else STATUS_PAGE
    report = run(path)
    print(format_report(report))
    return 0 if report.ok else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
