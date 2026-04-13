from pathlib import Path

def test_eclipse_dependency_closure_instance_lock():
    text = Path("docs/math/ECLIPSE_DEPENDENCY_CLOSURE_INSTANCE.md").read_text(encoding="utf-8")
    assert "# Eclipse Dependency Closure Instance" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Instance" in text
    assert "## Target" in text
    assert "## Certification form" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{DependencyClosed}(\\mathcal P_0)" in text
    assert "\\operatorname{Pred}_{D_0}(k)\\subseteq K_0" in text
    assert "every dependency edge of \\(D_0\\) has both source and target in \\(K_0\\)" in text
