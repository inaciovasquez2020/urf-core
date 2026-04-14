from pathlib import Path

def test_perelman_pl_0004_replay_lock():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0004.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0004}" in text
    assert r"\textbf{Source: } \texttt{perelman\_2003\_surgery}" in text
    assert r"\textbf{Source Locator: } \text{Section 73--77}" in text
    assert r"\textbf{Dependencies: } \mathrm{PL\mbox{-}0002},\ \mathrm{PL\mbox{-}0003}" in text
    assert "Witness" in text
    assert "Assumptions" in text
    assert "Conclusion" in text
    assert "Dependency Inputs" in text
    assert "Source-to-Claim Map" in text
    assert "Local Verification Notes" in text
    assert "Open Gaps" in text
    assert r"\mathrm{PL\mbox{-}0004}=\texttt{verified}" in text
