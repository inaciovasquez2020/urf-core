#!/usr/bin/env python3
"""Exact S3 global-class vs independently conjugated loop-observation audit.

Enumeration is exhaustive for k=1..4. Uniform prior is on global
simultaneous-conjugacy classes, NOT on raw S3^k assignments.
No Lean, physical dimensionality, or unrestricted graph theorem claimed.
"""
from collections import Counter, defaultdict
from fractions import Fraction
from itertools import permutations, product
from math import log2

if not __debug__:
    raise SystemExit('OPTIMIZED_EXECUTION_REJECTED')
G = tuple(permutations(range(3)))

def multiply(a, b):
    return tuple(a[b[i]] for i in range(3))

def inverse(a):
    return tuple(a.index(i) for i in range(3))

def conjugate(g, x):
    return multiply(multiply(g, x), inverse(g))

def global_class(t):
    return min(tuple(conjugate(g, x) for x in t) for g in G)

def observation(t):
    return tuple(min(conjugate(g, x) for g in G) for x in t)

def centralizer(g):
    return sum(multiply(g,x) == multiply(x,g) for x in G)

EXPECTED = {
    1: {1: 3},
    2: {1: 7, 2: 2},
    3: {1: 13, 2: 9, 3: 3, 4: 1, 5: 1},
    4: {1: 21, 2: 24, 3: 12, 4: 8, 5: 4, 6: 6, 8: 1, 9: 4, 14: 1},
}

def run():
    assert len(G) == 6
    assert sorted(centralizer(g) for g in G) == [2,2,2,3,3,6]
    for k, expected in EXPECTED.items():
        fibers = defaultdict(set)
        for t in product(G, repeat=k):
            fibers[observation(t)].add(global_class(t))
        hist = Counter(len(v) for v in fibers.values())
        assert dict(hist) == expected, (k, hist)
        count_global = sum(length * multiplicity for length, multiplicity in hist.items())
        count_local = sum(hist.values())
        independent_burnside = sum(centralizer(g)**k for g in G)//len(G)
        assert count_global == independent_burnside
        assert count_local == 3**k
        optimal = Fraction(count_local, count_global)
        # H(global | local) = (1/N) sum_signature size(fiber)*log2(size(fiber))
        entropy = sum(Fraction(length * multiplicity, count_global)*log2(length)
                      for length,multiplicity in hist.items())
        assert 0 <= entropy <= log2(count_global)
        assert all(len(classes) > 0 for classes in fibers.values())
        print(f'K={k} GLOBAL={count_global} OBS={count_local} '
              f'HIST={dict(sorted(hist.items()))} OPTIMAL={optimal} '
              f'CONDITIONAL_ENTROPY_BITS={entropy:.12f} PASS')
    a,b = (1,0,2),(0,2,1)
    assert observation((a,a)) == observation((a,b))
    assert global_class((a,a)) != global_class((a,b))
    print('EXPLICIT_COLLISION := PASS')
    print('EXACT_COMBINATORIAL_AUDIT := PASS')
    print('LEAN_VERIFIED := NOT_RUN; PHYSICAL_5D_NECESSITY := OPEN')

if __name__ == '__main__':
    run()
