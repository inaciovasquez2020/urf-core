from pathlib import Path

def test_prefab_spec_exists():
    assert Path("docs/PREFAB_SPEC.md").exists()

def test_quickstart_example_exists():
    assert Path("examples/quickstart.md").exists()
