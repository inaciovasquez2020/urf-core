from pathlib import Path

def test_prefab_docs():
    assert Path("docs/PREFAB_CONTRACT.md").exists()
    assert Path("examples/minimal_prefab.md").exists()
