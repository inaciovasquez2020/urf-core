from pathlib import Path


DOC = Path("docs/foundations/SHADOW_OF_INFINITY.md")
RECEIPT = Path(
    "artifacts/status/shadow_of_infinity_motion_band_boundary_receipt_2026_07_07.json"
)


def test_motion_band_shadow_definition_is_bounded_input_object():
    s = DOC.read_text()

    assert "Motion Band Shadow Boundary" in s
    assert r"\mathrm{MotionBandShadow}(V,c,v) := V < v \wedge v < c" in s
    assert "explicit input lower speed bound" in s
    assert "not a theorem" in s
    assert (
        r"\mathrm{BOUNDARY} := \neg\ \mathrm{universal\_physical\_minimum\_nonzero\_speed\_proved}"
        in s
    )


def test_shadow_of_infinity_does_not_imply_time_dilation():
    s = DOC.read_text()

    assert "does not assert or imply physical time dilation" in s
    assert "Shadow of Infinity implies physical time dilation" in s


def test_minimum_speed_is_not_promoted_to_theorem():
    s = DOC.read_text()
    receipt = RECEIPT.read_text()

    assert "v_{\\min}" in s
    assert "explicit assumption" in s
    assert "v_min is promoted from explicit input to theorem" in receipt
    assert "BOUNDARY := ¬ universal_physical_minimum_nonzero_speed_proved" in receipt
