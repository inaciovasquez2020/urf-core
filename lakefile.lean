import Lake
open Lake DSL

package urf_core

require mathlib from git
  "https://github.com/leanprover-community/mathlib4"

lean_lib UrfCore {
  srcDir := "src"
}

lean_exe urf_tests {
  root := `src.Main
}


/-
CI compatibility shim
Ensures `lake exe cache get` exists for Lean Action Mathlib cache step
-/
require mathlib from git
  "https://github.com/leanprover-community/mathlib4"

