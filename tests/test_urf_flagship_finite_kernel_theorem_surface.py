import json
import re
import subprocess
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
LEAN_FILE = BASE / "lean/URF/Foundation/FlagshipFiniteKernelTheoremSurface.lean"
ARTIFACT = BASE / "artifacts/urf/urf_flagship_finite_kernel_theorem_surface_2026_06_02.json"
STATUS_MD = BASE / "docs/status/URF_FLAGSHIP_FINITE_KERNEL_THEOREM_SURFACE_2026_06_02.md"
GRAPH = BASE / "artifacts/urf/urf_flagship_finite_kernel_theorem_dependency_graph_2026_06_02.dot"

def strip_lean_comments(text: str) -> str:
    text = re.sub(r"/-.*?-/", " ", text, flags=re.DOTALL)
    text = re.sub(r"--[^\n]*", "", text)
    return text

def test_flagship_files_exist():
    assert LEAN_FILE.exists()
    assert ARTIFACT.exists()
    assert STATUS_MD.exists()
    assert GRAPH.exists()

def test_flagship_theorem_is_nontrivial_kernel_statement():
    text = LEAN_FILE.read_text()
    code = strip_lean_comments(text)
    assert "structure FinDist" in code
    assert "structure FinKernel" in code
    assert "theorem flagship_finite_kernel_theorem_surface" in code
    assert "(K.transition a).nonneg b" in code
    assert "(K.transition a).sum_one" in code
    assert not re.search(r"theorem\s+flagship_finite_kernel_theorem_surface[\s\S]*?:\s*True\s*:=", code)

def test_no_forbidden_proof_tokens_in_code():
    code = strip_lean_comments(LEAN_FILE.read_text()).lower()
    for term in ["axiom", "admit", "sorry"]:
        assert not re.search(rf"\b{term}\b", code)

def test_artifact_records_lake_registered_dependency_boundary():
    data = json.loads(ARTIFACT.read_text())
    assert data["theorem_name"] == "flagship_finite_kernel_theorem_surface"
    assert data["theorem_class"] == "NONTRIVIAL_LAKE_REGISTERED_LEAN_CHECKED_FLAGSHIP_THEOREM"
    assert data["dependency_mode"] == "lake_registered_importable_module"
    assert data["minimal_missing_dependency_anchor"] == "NONE"
    assert data["root_import_file"] == "lean/URF.lean"
    assert data["is_trivially_true_only"] is False
    assert data["uses_axiom"] is False
    assert data["uses_admit"] is False
    assert data["uses_sorry"] is False
    assert data["next_admissible_object"] == "CommitFlagshipFiniteKernelTheoremSurface"

def test_status_records_lake_registered_import():
    text = STATUS_MD.read_text()
    assert "import URF.Foundation.FlagshipFiniteKernelTheoremSurface" in text
    assert "Finite-kernel theorem surface only" in text

def test_graph_records_theorem_dependencies():
    text = GRAPH.read_text()
    assert "FinDist.nonneg" in text
    assert "FinDist.sum_one" in text
    assert "flagship_finite_kernel_theorem_surface" in text

def test_verifier_passes():
    result = subprocess.run(
        ["python3", "tools/verify_urf_flagship_finite_kernel_theorem_surface.py"],
        cwd=BASE,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "URF_FLAGSHIP_FINITE_KERNEL_THEOREM_SURFACE_OK" in result.stdout
    assert '"decision": "PASS"' in result.stdout
