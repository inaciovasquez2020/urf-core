"""Conservative lexical scanner; not a Lean kernel audit."""

import re

def strip_noncode(text):
    out = []
    i = 0
    depth = 0
    quoted = False

    def blank(s):
        return "".join("\n" if c == "\n" else " " for c in s)

    while i < len(text):
        if depth:
            if text.startswith("/-", i):
                depth += 1
                out.append("  ")
                i += 2
            elif text.startswith("-/", i):
                depth -= 1
                out.append("  ")
                i += 2
            else:
                out.append(blank(text[i]))
                i += 1
        elif quoted:
            if text[i] == "\\" and i + 1 < len(text):
                out.append(blank(text[i:i+2]))
                i += 2
            elif text[i] == '"':
                quoted = False
                out.append(" ")
                i += 1
            else:
                out.append(blank(text[i]))
                i += 1
        elif text.startswith("--", i):
            j = text.find("\n", i)
            if j < 0:
                j = len(text)
            out.append(blank(text[i:j]))
            i = j
        elif text.startswith("/-", i):
            depth = 1
            out.append("  ")
            i += 2
        elif text[i] == '"':
            quoted = True
            out.append(" ")
            i += 1
        else:
            out.append(text[i])
            i += 1

    if depth or quoted:
        raise ValueError("Unterminated comment or string")

    return "".join(out)

PATTERN = re.compile(r"\b(?:axiom|admit|sorry)\b")

def obligations(text):
    code = strip_noncode(text)
    for i, line in enumerate(code.splitlines(), 1):
        if PATTERN.search(line):
            yield i, line.strip()
