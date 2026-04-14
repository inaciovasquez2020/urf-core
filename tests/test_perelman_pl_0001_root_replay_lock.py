from pathlib import Path

def test_perelman_pl_0001_root_replay_lock():
    text = Path("docs/math/PERELMAN_REPLAY_PL_0001.md").read_text(encoding="utf-8")
    assert "Status: OPEN." in text
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0001}" in text
    assert r"\textbf{Source: } \texttt{morgan\_tian}" in text
    assert r"\textbf{Source Locator: } \text{global}" in text
    assert r"\mathrm{PL\mbox{-}0002},\ \mathrm{PL\mbox{-}0003},\ \mathrm{PL\mbox{-}0004},\ \mathrm{PL\mbox{-}0005},\ \mathrm{PL\mbox{-}0006}" in text
    assert "Witness" in text
    assert "Assumptions" in text
    assert "Conclusion" in text
    assert "Dependency Inputs" in text
    assert "Source-to-Claim Map" in text
    assert "Local Verification Notes" in text
    assert "Open Gaps" in text
    assert r"\bigwedge_{i=2}^{6}\mathrm{PL\mbox{-}000i}=\texttt{verified}" in text
