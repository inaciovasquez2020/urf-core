#!/usr/bin/env python3
"""Exact finite rational audit for three-edge Z/12 holonomy classification."""
from fractions import Fraction as Q
from itertools import product

# Python optimization strips assertions; never certify a stripped execution.
if not __debug__:
    raise SystemExit("OPTIMIZED_EXECUTION_REJECTED: assertions are disabled")

MOD = 12
M = 3

def circle_dist(x, k):
    """Compute circular distance between a real lift and integer class."""
    d = (x - k) % MOD
    return min(d, MOD-d)

def candidates(observed):
    """Return all closest integer holonomy classes to measured edges."""
    dist = [circle_dist(sum(observed), k) for k in range(MOD)]
    best = min(dist)
    return [k for k, d in enumerate(dist) if d == best]

def exhaustive(delta):
    """Count outcomes over a finite grid of exact rational edge errors."""
    tests = 0
    unique_correct = 0
    ambiguous = 0
    wrong = 0
    first = None
    for k, errors in product(range(MOD), product((-delta, Q(0), delta), repeat=M)):
        a = (Q(k), Q(0), Q(0))
        obs = tuple(v+e for v, e in zip(a, errors))
        decoded = candidates(obs)
        tests += 1
        if decoded == [k]: unique_correct += 1
        elif k in decoded: ambiguous += 1
        else: wrong += 1
        if len(decoded) != 1 and first is None: first = (k, errors, decoded)
    return tests, unique_correct, ambiguous, wrong, first

for delta in (Q(1, 7), Q(1, 6), Q(1, 5)):
    result = exhaustive(delta)
    tests, correct, ambiguous, wrong, first = result
    assert tests == MOD * 3**M
    if delta == Q(1, 7):
        assert (correct, ambiguous, wrong) == (324, 0, 0)
    elif delta == Q(1, 6):
        assert (correct, ambiguous, wrong) == (300, 24, 0)
    else:
        assert (correct, ambiguous, wrong) == (300, 0, 24)
    print('delta=', delta, 'counts=', result)

# Explicit annulus: outer vertices 0,1,2; inner 3,4,5.
# Each triangle's curvature is computed from oriented edge values,
# not from a symbolic expression which cancels by construction.
faces = ((0,1,4),(0,4,3),(1,2,5),(1,5,4),(2,0,3),(2,3,5))
arcs = {(0,1):0,(1,2):0,(2,0):1,(3,4):0,(4,5):0,(5,3):1,
        (0,3):0,(1,4):0,(2,5):0,(0,4):0,(1,5):0,(2,3):1}
def transport(u,v):
    """Read an oriented annulus edge value, reversing signs as needed."""
    if (u,v) in arcs:
        return arcs[(u,v)]
    if (v,u) in arcs:
        return -arcs[(v,u)]
    raise ValueError((u,v))
def cycle_holonomy(vertices):
    """Compute directed cycle holonomy from explicit edge values."""
    return sum(transport(vertices[i], vertices[(i+1)%len(vertices)])
               for i in range(len(vertices))) % MOD
face_curvatures = [cycle_holonomy(f) for f in faces]
outer_holonomy = cycle_holonomy((0,1,2))
inner_holonomy = cycle_holonomy((3,4,5))
assert face_curvatures == [0]*6
assert outer_holonomy == inner_holonomy == 1
# Adversarial defect: flipping an outer boundary edge destroys flatness.
arcs[(0,1)] += 1
assert any(cycle_holonomy(f) != 0 for f in faces)
arcs[(0,1)] -= 1
print('annulus_faces=',face_curvatures,'outer_holonomy=',outer_holonomy,
      'inner_holonomy=',inner_holonomy,'PERTURBATION_REJECTED := PASS')

# Exact adversarial indistinguishability at equality delta = 1/(2m).
mid = tuple(Q(1,2*M) for _ in range(M))
a0 = tuple(Q(0) for _ in range(M))
a1 = tuple(Q(1,M) for _ in range(M))
assert max(abs(x-y) for x,y in zip(mid,a0)) == Q(1,2*M)
assert max(abs(x-y) for x,y in zip(mid,a1)) == Q(1,2*M)
assert candidates(mid) == [0,1]
print('sharp_midpoint=',mid,'classes=', candidates(mid))
