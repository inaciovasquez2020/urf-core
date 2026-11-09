#!/usr/bin/env python3
"""Exact finite rational audit for three-edge Z/12 holonomy classification."""
from fractions import Fraction as Q
from itertools import product

MOD = 12
M = 3

def circle_dist(x, k):
    d = (x - k) % MOD
    return min(d, MOD-d)

def candidates(observed):
    dist = [circle_dist(sum(observed), k) for k in range(MOD)]
    best = min(dist)
    return [k for k, d in enumerate(dist) if d == best]

def exhaustive(delta):
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
    print('delta=', delta, 'counts=', exhaustive(delta))

# Flat six-face annulus: outer O_i, inner I_i; radials zero.
# Outer/inner cycle edges and the diagonal O_i -> I_(i+1) carry q_i.
q = (0, 0, 1)
faces = []
for i in range(3):
    # face O_i -> O_(i+1) -> I_(i+1) -> O_i
    faces.append((q[i]+0-q[i]) % MOD)
    # face O_i -> I_(i+1) -> I_i -> O_i
    faces.append((q[i]-q[i]+0) % MOD)
assert all(f == 0 for f in faces)
assert sum(q) % MOD == 1
print('annulus_faces=', faces, 'outer_holonomy=',sum(q)%MOD, 'inner_holonomy=',sum(q)%MOD)

# Exact adversarial indistinguishability at equality delta = 1/(2m).
mid = tuple(Q(1,2*M) for _ in range(M))
a0 = tuple(Q(0) for _ in range(M))
a1 = tuple(Q(1,M) for _ in range(M))
assert max(abs(x-y) for x,y in zip(mid,a0)) == Q(1,2*M)
assert max(abs(x-y) for x,y in zip(mid,a1)) == Q(1,2*M)
assert candidates(mid) == [0,1]
print('sharp_midpoint=',mid,'classes=', candidates(mid))
