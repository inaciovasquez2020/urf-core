from pathlib import Path

def test_envelope_witness_inclusion_reduction_mentions_kernel_obligation() -> None:
    s = Path("docs/math/ENVELOPE_WITNESS_INCLUSION_REDUCTION.md").read_text()
    assert "ENVELOPE_WITNESS_INCLUSION_KERNEL_OBLIGATION.md" in s
