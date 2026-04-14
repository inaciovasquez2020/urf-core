from pathlib import Path

def test_perelman_replay_lock_chain():
    p1 = Path("docs/math/PERELMAN_REPLAY_PL_0001.md").read_text(encoding="utf-8")
    p2 = Path("docs/math/PERELMAN_REPLAY_PL_0002.md").read_text(encoding="utf-8")
    p3 = Path("docs/math/PERELMAN_REPLAY_PL_0003.md").read_text(encoding="utf-8")
    p4 = Path("docs/math/PERELMAN_REPLAY_PL_0004.md").read_text(encoding="utf-8")
    p5 = Path("docs/math/PERELMAN_REPLAY_PL_0005.md").read_text(encoding="utf-8")
    p6 = Path("docs/math/PERELMAN_REPLAY_PL_0006.md").read_text(encoding="utf-8")

    assert r"\mathrm{PL\mbox{-}0002}" in p1
    assert r"\mathrm{PL\mbox{-}0003}" in p1
    assert r"\mathrm{PL\mbox{-}0004}" in p1
    assert r"\mathrm{PL\mbox{-}0005}" in p1
    assert r"\mathrm{PL\mbox{-}0006}" in p1

    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0002}" in p2
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0003}" in p3
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0004}" in p4
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0005}" in p5
    assert r"\textbf{Lemma ID: } \mathrm{PL\mbox{-}0006}" in p6

    assert r"\textbf{Dependencies: } \mathrm{PL\mbox{-}0002}" in p3
    assert r"\textbf{Dependencies: } \mathrm{PL\mbox{-}0002},\ \mathrm{PL\mbox{-}0003}" in p4
    assert r"\textbf{Dependencies: } \mathrm{PL\mbox{-}0004}" in p5
    assert r"\textbf{Dependencies: } \mathrm{PL\mbox{-}0005}" in p6
