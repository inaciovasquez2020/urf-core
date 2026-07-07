from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

doc = ROOT / "docs/foundations/SHADOW_OF_INFINITY.md"
motion_receipt = ROOT / "artifacts/status/shadow_of_infinity_motion_band_boundary_receipt_2026_07_07.json"
relative_receipt = ROOT / "artifacts/status/shadow_of_infinity_relative_time_scale_boundary_receipt_2026_07_07.json"

for path in [doc, motion_receipt, relative_receipt]:
    if not path.exists():
        raise SystemExit(f"MISSING_OBJECT := {path.relative_to(ROOT)}")

doc_text = doc.read_text(encoding="utf-8")
motion_text = motion_receipt.read_text(encoding="utf-8")
relative_text = relative_receipt.read_text(encoding="utf-8")
joined = "\n".join([doc_text, motion_text, relative_text])

required_tokens = [
    r"\mathrm{MotionBandShadow}(V,c,v) := V < v \wedge v < c",
    r"\mathrm{RelativeTimeScale}(S,t) :=",
    "MotionBandShadow(V,c,v) := V < v ∧ v < c",
    "RelativeTimeScale(S,t) := elapsed_time(S,t) / natural_cycle_time(S)",
    "BOUNDARY := ¬ universal_physical_minimum_nonzero_speed_proved",
    "BOUNDARY := ¬ RelativeTimeScale_proves_physical_time_dilation",
    "does not assert or imply physical time dilation",
    "Neither object derives physical time dilation",
]

for token in required_tokens:
    if token not in joined:
        raise SystemExit(f"MISSING_OBJECT := token {token!r}")

for forbidden_token in [
    '"status": "theorem"',
    '"classification": "same theory"',
    "universal_physical_minimum_nonzero_speed_proved := true",
    "RelativeTimeScale_proves_physical_time_dilation := true",
]:
    if forbidden_token in joined:
        raise SystemExit(f"BOUNDARY := forbidden promotion present: {forbidden_token}")

print("SHADOW_OF_INFINITY_MOTION_RELATIVE_TIME_BOUNDARY_OK")
