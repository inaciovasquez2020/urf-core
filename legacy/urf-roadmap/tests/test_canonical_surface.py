from pathlib import Path

def test_canonical_files_exist():
    for f in ["README.md", "STATUS.md", "FREEZE.md", "CITATION.cff"]:
        assert Path(f).exists(), f

def test_readme_identity():
    txt = Path("README.md").read_text()
    assert "URF Roadmap" in txt
    assert "Unified Rigidity Framework" in txt

def test_status_identity():
    txt = Path("STATUS.md").read_text()
    assert "URF Roadmap" in txt or "Unified Rigidity Framework roadmap" in txt
    assert "`main` is canonical" in txt
