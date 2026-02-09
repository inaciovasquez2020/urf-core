#!/usr/bin/env python3
import itertools, json, math, sys
from typing import List, Tuple

def mat_vec_mod2(A: List[List[int]], x: List[int]) -> List[int]:
    m = len(A)
    n = len(x)
    out = [0]*m
    for i in range(m):
        s = 0
        row = A[i]
        for j in range(n):
            s ^= (row[j] & x[j])
        out[i] = s
    return out

def satisfies(A: List[List[int]], b: List[int], x: List[int]) -> bool:
    return mat_vec_mod2(A, x) == b

def entropy_bits(p: List[float]) -> float:
    h = 0.0
    for x in p:
        if x <= 0.0:
            continue
        h -= x * math.log2(x)
    return h

def posterior_over_solutions(solutions: List[Tuple[int,...]], predicate) -> List[float]:
    keep = [s for s in solutions if predicate(s)]
    if not keep:
        raise ValueError("empty posterior support")
    w = 1.0 / len(keep)
    p = [w if s in keep else 0.0 for s in solutions]
    return p

def main():
    out_path = "tools/chronos_cert/examples/xor_enum_3vars/CERT.json"

    A = [
        [1,1,0],
        [0,1,1]
    ]
    b = [0,1]

    n = 3
    all_x = list(itertools.product([0,1], repeat=n))
    sols = [x for x in all_x if satisfies(A,b,list(x))]
    if len(sols) == 0:
        raise ValueError("no solutions")

    solutions = sols
    M = len(solutions)

    def q1(x): 
        return x[1] == 0

    def q2(x):
        return x[0] == 1

    P0 = [1.0/M]*M
    P1 = posterior_over_solutions(solutions, q1)
    P2 = posterior_over_solutions(solutions, lambda s: q1(s) and q2(s))

    H0 = entropy_bits(P0)
    H1 = entropy_bits(P1)
    H2 = entropy_bits(P2)

    cert = {
        "instance": {
            "name": "xor_enum_3vars",
            "n_states": M,
            "H0_lower": float(H0)
        },
        "bound": {
            "C": float(max(H0-H1, H1-H2)),
            "epsilon": float(H2)
        },
        "trace": {
            "posteriors": [
                {"p": P0},
                {"p": P1},
                {"p": P2}
            ]
        }
    }

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(cert, f, indent=2)

    print("wrote", out_path)
    print("M", M)
    print("H0 H1 H2", H0, H1, H2)

if __name__ == "__main__":
    main()
