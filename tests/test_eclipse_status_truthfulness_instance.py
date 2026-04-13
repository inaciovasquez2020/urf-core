from pathlib import Path

def test_eclipse_status_truthfulness_instance_lock():
    text = Path("docs/math/ECLIPSE_STATUS_TRUTHFULNESS_INSTANCE.md").read_text(encoding="utf-8")
    assert "# Eclipse Status Truthfulness Instance" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Instance" in text
    assert "## Target" in text
    assert "## Certification form" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{StatusTruthful}(\\mathcal P_0)" in text
    assert "S_0(k)=\\mathrm{PROVED}\\Rightarrow W_0(k)\\text{ certifies }k" in text
    assert "S_0(k)=\\mathrm{CONDITIONAL}\\Rightarrow W_0(k)\\text{ certifies the exact missing hypothesis or lemma for }k" in text
    assert "S_0(k)=\\mathrm{OPEN}\\Rightarrow W_0(k)\\text{ certifies absence of a proof of }k" in text
