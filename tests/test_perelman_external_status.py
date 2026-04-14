from pathlib import Path

def test_perelman_external_status_lock():
    text = Path("docs/status/PERELMAN_EXTERNAL_STATUS.md").read_text(encoding="utf-8")
    assert "Conditional." in text
    assert r"\text{Problem}=\text{Poincaré Conjecture}." in text
    assert r"\text{External status}=\text{Solved}." in text
    assert r"\text{Accepted solver}=\text{Grigori Perelman}." in text
    assert r"\text{Toolkit status}=\texttt{Externally\ Accepted / Internally\ Not\ Re\mbox{-}run}." in text
    assert r"\texttt{Externally\ Accepted / Internally\ Not\ Re\mbox{-}run}" in text
    assert r"\texttt{Internally\ Verified}" in text
    assert r"\text{full toolkit replay artifact exists}." in text
