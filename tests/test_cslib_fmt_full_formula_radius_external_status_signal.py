import subprocess


def test_cslib_fmt_full_formula_radius_external_status_signal():
    subprocess.run(
        ["python3", "-B", "tools/verify_cslib_fmt_full_formula_radius_external_status_signal.py"],
        check=True,
    )
