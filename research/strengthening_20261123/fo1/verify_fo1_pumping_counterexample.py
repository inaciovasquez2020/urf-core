#!/usr/bin/env python3
"""Reproducible exact finite check of FO¹ graph-type and K4 pumping counterexample.

A finite check is not the full mathematical induction proof. Companion Lean
candidate: URF_FO1_FixedSemanticCounterexample.lean (NOT_RUN until compiled).
"""
from itertools import combinations
from functools import lru_cache
import hashlib

# Canonical syntax over {E(x,x), x=x, ¬, ∧, ∃x}; size <= 5.
@lru_cache(maxsize=None)
def formulas(size):
    if size == 1:
        return (("eq",), ("edge",))
    f = [("not", p) for p in formulas(size - 1)]
    f.extend(("exists", p) for p in formulas(size - 1))
    for left_size in range(1, size - 1):
        for p in formulas(left_size):
            for q in formulas(size - left_size - 1):
                f.append(("and", p, q))
    return tuple(f)

ALL = tuple(x for size in range(1, 6) for x in formulas(size))


def sat(phi, graph, vertex, n):
    op = phi[0]
    if op == "eq":
        return True
    if op == "edge":
        return (vertex, vertex) in graph
    if op == "not":
        return not sat(phi[1], graph, vertex, n)
    if op == "and":
        return sat(phi[1], graph, vertex, n) and sat(phi[2], graph, vertex, n)
    if op == "exists":
        return any(sat(phi[1], graph, w, n) for w in range(n))
    raise AssertionError(op)


def ball(n, edges, v, radius):
    seen = {v}
    for _ in range(radius):
        seen |= {w for a, b in edges for w in (
            ((b,) if a in seen else ()) + ((a,) if b in seen else ())
        )}
    return seen


def betti1_ball(n, edges, v, radius):
    vertices = ball(n, edges, v, radius)
    contained = sum(1 for a, b in edges if a in vertices and b in vertices)
    # A graph-distance ball is connected.
    return contained - len(vertices) + 1


def gf2_rank_incidence(n, edges):
    """Independent Gaussian-elimination rank of the F2 incidence matrix."""
    pivots = {}
    for u, v in edges:
        col = (1 << u) ^ (1 << v)
        while col:
            lead = col.bit_length() - 1
            if lead in pivots:
                col ^= pivots[lead]
            else:
                pivots[lead] = col
                break
    return len(pivots)


def check_ball_cycle_rank(n, edges, root, radius):
    vertices = ball(n, edges, root, radius)
    contained = tuple((u, v) for u, v in edges if u in vertices and v in vertices)
    euler = len(contained) - len(vertices) + 1
    algebra = len(contained) - gf2_rank_incidence(n, contained)
    assert euler == algebra, (n, edges, root, radius, euler, algebra)
    return algebra


def validate():
    assert sum(len(formulas(size)) for size in range(1, 6)) == len(ALL)
    examined_graphs = 0
    eval_checks = 0
    pumping_counterexample_graphs = 0
    pumping_counterexample_delta3 = 0
    rank_checks = 0
    local_ball_checks = 0
    K4 = frozenset(combinations(range(4), 2))
    E0 = frozenset()
    for n in range(1, 6):
        possible = tuple(combinations(range(n), 2))
        for bits in range(1 << len(possible)):
            edges = frozenset(e for i, e in enumerate(possible) if (bits >> i) & 1)
            examined_graphs += 1
            G = set(edges) | {(b, a) for a, b in edges}
            for phi in ALL:
                # Exact interpreter comparisons for all vertices and both graph objects.
                baseline = sat(phi, G, 0, n)
                for v in range(n):
                    assert sat(phi, G, v, n) == baseline
                    assert sat(phi, frozenset(), v, n) == baseline
                    eval_checks += 2
            qualifies = False
            for v in range(n):
                beta = check_ball_cycle_rank(n, edges, v, 2)
                rank_checks += 1
                qualifies |= beta > 1
                vertices = sorted(ball(n, edges, v, 1))
                index = {x: i for i, x in enumerate(vertices)}
                local_graph = set()
                for u, w in edges:
                    if u in index and w in index:
                        local_graph.add((index[u], index[w]))
                        local_graph.add((index[w], index[u]))
                for phi in ALL:
                    assert sat(phi, local_graph, index[v], len(vertices)) == sat(phi, E0, 0, 1)
                    local_ball_checks += 1
            if qualifies:
                pumping_counterexample_graphs += 1
                if all(sum(1 for a, b in edges if a == v or b == v) <= 3 for v in range(n)):
                    pumping_counterexample_delta3 += 1
    assert betti1_ball(4, K4, 0, 2) == 3
    assert len(K4) == 6
    assert pumping_counterexample_graphs > 0
    for phi in ALL:
        assert all(sat(phi, set(K4) | {(b, a) for a, b in K4}, v, 4)
                   == sat(phi, E0, 0, 4) for v in range(4))
    print('GF2_INCIDENCE_RANK_CROSS_CHECKS :=', rank_checks)
    print('ROOTED_RADIUS1_FO1_TYPE_CHECKS :=', local_ball_checks)
    print('FORMULAS_SIZE_LE_5 :=', len(ALL))
    print('ALL_SIMPLE_GRAPHS_UP_TO_5_VERTICES :=', examined_graphs)
    print('FORMULA_VERTEX_COMPARISONS :=', eval_checks)
    print('GRAPHS_WITH_K1_R1_PREMISE_TRUE :=', pumping_counterexample_graphs)
    print('GRAPHS_WITH_DELTA_LE_3_AND_PREMISE_TRUE :=', pumping_counterexample_delta3)
    print('K4_VERTICES := 4')
    print('K4_EDGES := 6')
    print('K4_BETTI1_BALL_R2 := 3')
    print('FO1_UNCOLORED_LOOPLESS_LOCAL_TYPE_COUNT := 1')
    print('K4_FO1_VERTEX_TYPE_SPLIT := FALSE')
    print('CONFIGURATION_PUMPING_AS_STATED_K1 := COUNTEREXAMPLE')
    print('LEAN := NOT_RUN')

if __name__ == '__main__':
    validate()