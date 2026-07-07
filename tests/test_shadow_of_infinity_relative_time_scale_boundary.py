from pathlib import Path
import json


DOC = Path("docs/foundations/SHADOW_OF_INFINITY.md")
RECEIPT = Path(
    "artifacts/status/shadow_of_infinity_relative_time_scale_boundary_receipt_2026_07_07.json"
)


def test_relative_time_scale_definition_is_explicit_input_object():
    s = DOC.read_text()

    assert "Relative Time Scale Boundary" in s
    assert r"\mathrm{RelativeTimeScale}(S,t) :=" in s
    assert r"\mathrm{elapsed\_time}(S,t)" in s
    assert r"\mathrm{natural\_cycle\_time}(S)" in s
    assert "explicit input, not a theorem" in s


def test_relative_time_scale_links_to_motion_band_shadow_only_as_analogy():
    s = DOC.read_text()

    assert r"\mathrm{MotionBandShadow}(V,c,v) := V < v \wedge v < c" in s
    assert "only as a bounded analogy" in s
    assert "Neither object derives physical time dilation" in s


def test_relative_time_scale_does_not_prove_physical_time_dilation():
    s = DOC.read_text()
    receipt = json.loads(RECEIPT.read_text())

    assert "RelativeTimeScale proves physical time dilation" in s
    assert (
        r"\mathrm{BOUNDARY} := \neg\ \mathrm{RelativeTimeScale\_proves\_physical\_time\_dilation}"
        in s
    )
    assert (
        receipt["boundary"]
        == "BOUNDARY := ¬ RelativeTimeScale_proves_physical_time_dilation"
    )
    assert "RelativeTimeScale proves physical time dilation" in receipt["forbidden_promotions"]


def test_natural_cycle_time_is_not_promoted_to_theorem():
    receipt = json.loads(RECEIPT.read_text())

    assert (
        receipt["input_boundaries"]["natural_cycle_time(S)"]
        == "explicit natural-cycle-time input, not a theorem"
    )
    assert (
        "natural_cycle_time(S) is promoted from explicit input to theorem"
        in receipt["forbidden_promotions"]
    )
