import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))

from lean_obligation_scan import obligations, strip_noncode

def test_comments_and_strings():
    text = (
        "-- sorry\n"
        "/- axiom /- admit -/ sorry -/\n"
        'def message := "sorry"\n'
        "theorem t : True := by\n"
        "  sorry\n"
        "axiom h : True\n"
    )
    result = list(obligations(text))
    assert [n for n, _ in result] == [5, 6]
    assert strip_noncode(text).count("\n") == text.count("\n")

def test_inline_comment():
    result = list(obligations("theorem t : True := by /- ignored -/ sorry"))
    assert len(result) == 1
