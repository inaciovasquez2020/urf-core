from pathlib import Path
import runpy

def test_dragon_internal_reference_doc_lock():
    text = Path("docs/examples/DRAGON_INTERNAL_REFERENCE.md").read_text(encoding="utf-8")
    assert "# DraG0n Internal Reference Example" in text
    assert "NON-CANONICAL EXAMPLE" in text
    assert "It is not part of the canonical foundation layer." in text
    assert "The canonical home of DraG0n foundations remains `docs/foundations/DRAG0N.md`." in text
    assert "weights" in text
    assert "thresholds `tau`" in text
    assert "per-wall effect tables" in text

def test_dragon_internal_reference_script_executes():
    runpy.run_path("artifacts/examples/dragon_internal_clay_reference.py", run_name="__main__")
