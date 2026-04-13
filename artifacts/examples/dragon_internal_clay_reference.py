from dataclasses import dataclass
from itertools import combinations

WEIGHTS = {"res": 0.25, "miss": 0.25, "block": 0.25, "regime": 0.25}

@dataclass(frozen=True)
class Problem:
    name: str
    status: str
    tau: float
    base: dict[str, float]
    effects: dict[str, dict[str, float]]

def score(state: dict[str, float]) -> float:
    return sum(WEIGHTS[k] * state[k] for k in WEIGHTS)

def apply(problem: Problem, choice: tuple[str, ...]) -> dict[str, float]:
    state = dict(problem.base)
    for z in choice:
        eff = problem.effects[z]
        for k in WEIGHTS:
            state[k] = max(0.0, state[k] - eff[k])
    return state

def dragon(problem: Problem, k: int):
    names = tuple(problem.effects.keys())
    base0 = score(problem.base)
    best_state = dict(problem.base)
    best_score = base0
    best_choice: tuple[str, ...] = ()
    for r in range(1, min(k, len(names)) + 1):
        for choice in combinations(names, r):
            state = apply(problem, choice)
            s = score(state)
            if s < best_score - 1e-12:
                best_score = s
                best_choice = choice
                best_state = state
    gain = base0 - best_score
    decision = 1 if gain + 1e-12 >= problem.tau else 0
    return base0, best_score, gain, best_choice, best_state, decision

problems = [
    Problem(
        name="birch_swinnerton_dyer",
        status="open",
        tau=0.90,
        base={"res": 1.80, "miss": 1.50, "block": 1.70, "regime": 1.20},
        effects={
            "Z_bsd_terminal_wall": {"res": 0.90, "miss": 0.70, "block": 0.90, "regime": 0.50},
            "Z_bsd_rank_regulator": {"res": 0.60, "miss": 0.50, "block": 0.40, "regime": 0.10},
        },
    ),
    Problem(
        name="hodge",
        status="open",
        tau=0.95,
        base={"res": 1.60, "miss": 1.20, "block": 1.80, "regime": 1.10},
        effects={
            "Z_hodge_arithmetic_rigidity": {"res": 0.80, "miss": 0.60, "block": 1.00, "regime": 0.50},
            "Z_hodge_horizontal_torus": {"res": 0.60, "miss": 0.30, "block": 0.70, "regime": 0.20},
        },
    ),
    Problem(
        name="navier_stokes",
        status="open",
        tau=1.10,
        base={"res": 2.00, "miss": 1.70, "block": 1.90, "regime": 1.40},
        effects={
            "Z_ns_iecp": {"res": 0.20, "miss": 0.20, "block": 0.90, "regime": 0.90},
            "Z_ns_ra1n": {"res": 0.90, "miss": 0.80, "block": 0.30, "regime": 0.10},
        },
    ),
    Problem(
        name="p_vs_np",
        status="open",
        tau=1.20,
        base={"res": 1.90, "miss": 1.60, "block": 2.10, "regime": 1.50},
        effects={
            "Z_pnp_support_rigidity": {"res": 0.80, "miss": 0.60, "block": 1.10, "regime": 0.70},
            "Z_pnp_patch_rank": {"res": 0.60, "miss": 0.60, "block": 0.70, "regime": 0.20},
        },
    ),
    Problem(
        name="poincare",
        status="solved_baseline",
        tau=0.10,
        base={"res": 0.00, "miss": 0.00, "block": 0.00, "regime": 0.00},
        effects={},
    ),
    Problem(
        name="riemann_hypothesis",
        status="open",
        tau=1.00,
        base={"res": 1.70, "miss": 1.40, "block": 1.80, "regime": 1.30},
        effects={
            "Z_rh_terminal_positivity": {"res": 0.90, "miss": 0.70, "block": 0.90, "regime": 0.60},
            "Z_rh_euler_gram": {"res": 0.60, "miss": 0.40, "block": 0.50, "regime": 0.20},
        },
    ),
    Problem(
        name="yang_mills",
        status="open",
        tau=1.05,
        base={"res": 1.80, "miss": 1.50, "block": 1.90, "regime": 1.40},
        effects={
            "Z_ym_final_wall": {"res": 0.70, "miss": 0.50, "block": 0.60, "regime": 0.30},
            "Z_ym_metric_gap": {"res": 0.20, "miss": 0.20, "block": 0.90, "regime": 0.80},
        },
    ),
]

def fmt(state: dict[str, float]) -> str:
    return ", ".join(f"{k}={state[k]:.2f}" for k in ("res", "miss", "block", "regime"))

def main() -> None:
    print("DraG0n internal Clay reference test")
    print(f"weights = {WEIGHTS}")
    print("=" * 84)
    print(
        f"{'problem':24} {'status':18} {'base':>6} {'gain1':>7} {'D1':>4} {'gain2':>7} {'D2':>4} "
        f"{'best1':28} {'best2':28}"
    )
    print("-" * 128)
    for p in problems:
        base1, best1, gain1, choice1, state1, d1 = dragon(p, 1)
        base2, best2, gain2, choice2, state2, d2 = dragon(p, 2)
        print(
            f"{p.name:24} {p.status:18} {base1:6.2f} {gain1:7.2f} {d1:4d} {gain2:7.2f} {d2:4d} "
            f"{str(choice1):28} {str(choice2):28}"
        )
    print("\nAssertions")
    print("=" * 84)
    assert next(p for p in problems if p.name == "poincare").status == "solved_baseline"
    for p in problems:
        base1, best1, gain1, choice1, state1, d1 = dragon(p, 1)
        base2, best2, gain2, choice2, state2, d2 = dragon(p, 2)
        assert gain2 + 1e-12 >= gain1
        if p.name == "poincare":
            assert abs(gain1) < 1e-12 and abs(gain2) < 1e-12
    print("PASS: monotonicity in k and solved-baseline check")

if __name__ == "__main__":
    main()
