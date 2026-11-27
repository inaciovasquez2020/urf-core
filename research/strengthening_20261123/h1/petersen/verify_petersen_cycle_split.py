#!/usr/bin/env python3
"""Exact independent finite witness for URF cycle-orbit splitting obstruction.

Uncolored simple graph KG(5,2), degree 3, radius 2. No third-party packages.
Finite checks support a separate elementary paper proof, not a Lean proof.
"""
import itertools
import os
import time
from collections import deque

DEADLINE = time.monotonic() + 20
V = tuple(itertools.combinations(range(5), 2))
lookup = {v: i for i, v in enumerate(V)}
n = len(V)
E = frozenset((i,j) for i in range(n) for j in range(i+1,n)
              if set(V[i]).isdisjoint(V[j]))
adj = {v: set() for v in range(n)}
for a,b in E:
    adj[a].add(b)
    adj[b].add(a)
assert (n, len(E)) == (10, 15)
assert {len(t) for t in adj.values()} == {3}

def distances(start):
    out = {start:0}
    queue = deque([start])
    while queue:
        v = queue.popleft()
        for w in adj[v]:
            if w not in out:
                out[w] = out[v]+1
                queue.append(w)
    return out

all_dist = tuple(distances(i) for i in range(n))
assert all(len(x) == n and max(x.values()) == 2 for x in all_dist)
assert {len([x for x in d.values() if x<=2]) for d in all_dist} == {10}

# F2 rank algorithm 1: xor-elimination of incidence columns.
def gf2_rank(columns):
    pivots = {}
    for original in columns:
        bits = original
        while bits:
            k = bits.bit_length()-1
            if k in pivots:
                bits ^= pivots[k]
            else:
                pivots[k] = bits
                break
    return len(pivots)
rank_incidence = gf2_rank([(1 << a) ^ (1 << b) for a,b in E])
cycle_dim_1 = len(E) - rank_incidence
assert rank_incidence == 9 and cycle_dim_1 == 6

# F2 cycle rank algorithm 2: independent spanning forest edge count.
seen = set()
components = 0
for start in range(n):
    if start in seen: continue
    components += 1
    seen.add(start)
    stack = [start]
    while stack:
        u = stack.pop()
        for w in adj[u]:
            if w not in seen:
                seen.add(w)
                stack.append(w)
cycle_dim_2 = len(E) - n + components
assert cycle_dim_2 == cycle_dim_1 == 6 and components == 1

# Every permutation of 5 base labels induces an automorphism of KG(5,2).
num_auto = 0
orbit = set()
for p in itertools.permutations(range(5)):
    if time.monotonic() > DEADLINE:
        print('STATUS := INCOMPLETE (time guard)')
        raise SystemExit(2)
    f = tuple(lookup[tuple(sorted((p[a],p[b])))] for a,b in V)
    assert len(set(f)) == n
    transformed = {tuple(sorted((f[a],f[b]))) for a,b in E}
    assert transformed == E
    num_auto += 1
    orbit.add(f[0])
assert num_auto == 120 and len(orbit) == n

# Uniform degree-3 radius-2 upper bound for every vertex ball.
max_vertices = 1 + 3 + 3*2
max_edges = 3*max_vertices // 2
max_cycle_rank = max_edges - max_vertices + 1
assert (max_vertices,max_edges,max_cycle_rank) == (10,15,6)

print('MODEL := KG(5,2) = Petersen, pure uncolored simple graph')
print('VERTICES :=',n)
print('EDGES :=',len(E))
print('DEGREES := 3')
print('DIAMETER := 2')
print('BALL_RADIUS_2 := all 10 vertices')
print('INCIDENCE_RANK_GF2 :=',rank_incidence)
print('CYCLE_DIM_GF2 :=',cycle_dim_1)
print('INDEPENDENT_CYCLE_RANK :=',cycle_dim_2)
print('VERIFIED_S5_AUTOMORPHISMS :=',num_auto)
print('VERTEX_ORBIT_SIZE :=',len(orbit))
print('UNIFORM_MAX_VERTEX_BOUND :=',max_vertices)
print('UNIFORM_MAX_EDGE_BOUND :=',max_edges)
print('UNIFORM_MAX_CYCLE_RANK :=',max_cycle_rank)
print('ALL_FO_K_ROOTED_VERTEX_TYPES_IDENTICAL := PROVED_BY_TRANSITIVITY')
print('TSTAR_LE_6 := COUNTEREXAMPLE_FOR_ALL_K')
print('TSTAR_GT_6 := VACUOUS_FOR_DELTA_3_R_1')
print('STATUS := COMPUTATION_PASS')
print('GENERAL_THEOREM := PAPER_PROOF_ONLY')
print('LEAN := NOT_RUN')
