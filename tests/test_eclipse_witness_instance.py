from pathlib import Path

def test_eclipse_witness_instance_lock():
    text = Path("docs/math/ECLIPSE_WITNESS_INSTANCE.md").read_text(encoding="utf-8")
    assert "# Eclipse Witness Instance" in text
    assert "## Status" in text
    assert "Conditional." in text
    assert "## Instance" in text
    assert "K_0=\\{k_1,k_2,k_3,k_4\\}" in text
    assert "S_0(k_1)=\\mathrm{PROVED}" in text
    assert "S_0(k_4)=\\mathrm{OPEN}" in text
    assert "## Obligations" in text
    assert "### External reproducibility" in text
    assert "### Audit stability" in text
    assert "### Dependency closure" in text
    assert "### Status truthfulness" in text
    assert "## Target" in text
    assert "## Terminal missing object" in text
    assert "\\operatorname{Eclipse}(\\mathcal P_0)" in text
