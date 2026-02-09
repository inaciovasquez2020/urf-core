import Lake
open Lake DSL

package «urf-core» where
  moreLeanArgs := #[
    "-Dlinter.unusedVariables=false",
    "-Dlinter.unusedArguments=false"
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4"

@[default_target]
lean_lib URFCore where

lean_lib Spine where
  srcDir := "spine/lean"

lean_lib URFSpine where
  srcDir := "spine/lean"

lean_lib TVDuality where
  srcDir := "spine/lean"

lean_lib MeasureDuality where
  srcDir := "spine/lean"

