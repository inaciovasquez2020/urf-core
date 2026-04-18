from pathlib import Path

def test_urf_dependency_dag_has_root_and_quartet():
    text = Path("docs/status/URF_DEPENDENCY_DAG.md").read_text()
    for needle in [
        "urf-core",
        "chronos-urf-rr",
        "scientific-infrastructure",
        "urf-verifier",
    ]:
        assert needle in text
