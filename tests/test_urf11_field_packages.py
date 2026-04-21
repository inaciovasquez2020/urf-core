from pathlib import Path

ROOT = Path("docs/community/urf11/fields")
FIELD_DIRS = [
    "F1_agricultural_sciences_and_natural_resources",
    "F2_biological_and_biomedical_sciences",
    "F3_computer_and_information_sciences",
    "F4_engineering",
    "F5_geosciences_atmospheric_and_ocean_sciences",
    "F6_health_sciences",
    "F7_mathematics_and_statistics",
    "F8_multidisciplinary_interdisciplinary_sciences",
    "F9_physical_sciences",
    "F10_psychology",
    "F11_social_sciences",
]
REQUIRED_FILES = [
    "ANCHOR_PROBLEM.md",
    "SUBPROBLEMS.md",
    "BRIDGES.md",
    "INVITATION.md",
    "ACCEPTANCE_TESTS.md",
    "BENCHMARKS.md",
]

def V_field(field_dir: Path) -> bool:
    for name in REQUIRED_FILES:
        p = field_dir / name
        if not p.exists():
            return False
        text = p.read_text().strip()
        if not text or "## Status\nOPEN" not in text:
            return False
    code = field_dir.name.split("_", 1)[0]
    sub = (field_dir / "SUBPROBLEMS.md").read_text()
    bench = (field_dir / "BENCHMARKS.md").read_text()
    return all(tag in sub for tag in (f"{code}-S1", f"{code}-S2", f"{code}-S3")) and f"urf11/{code.lower()}_benchmark/v1" in bench

def test_all_required_field_files_exist():
    for dirname in FIELD_DIRS:
        field_dir = ROOT / dirname
        for name in REQUIRED_FILES:
            assert (field_dir / name).exists(), (field_dir / name)

def test_every_field_package_passes_V_field():
    for dirname in FIELD_DIRS:
        assert V_field(ROOT / dirname), dirname
