#!/usr/bin/env python3
"""Exact finite-map spectrum and finite S3 multi-loop audit.
Proof of unrestricted q-ary adaptive reconstruction is mathematical,
not inferred from these finite tests. No third-party dependencies.
"""
from itertools import product,permutations
from collections import Counter,defaultdict
from fractions import Fraction
from math import ceil,log
from time import monotonic
import sys,platform
START=monotonic(); TIME_LIMIT=55; STATE_LIMIT=800_000
C=Counter()
def guard():
    if monotonic()-START>TIME_LIMIT or C['assignments']>STATE_LIMIT:
        raise TimeoutError('INCOMPLETE: wall-clock/state guard')

def theoretical(fib,Q):
    success=sum(min(s,Q) for s in fib)
    product_min=1
    for s in fib:
        a,b=divmod(s,Q)
        product_min *= ((a+1)**(a+1))**b * (a**a if a else 1)**(Q-b)
    return success,product_min

def finite_test():
    for n in range(1,7):
        for M in range(1,min(n,3)+1):
            for obs in product(range(M),repeat=n):
                fib=Counter(obs)
                for Q in range(1,4):
                    best_success=0; best_product=None
                    ts=product(range(Q),repeat=n)
                    for t in ts:
                        guard(); counts=Counter(zip(obs,t))
                        success=len(counts)
                        cell_product=1
                        for v in counts.values():cell_product*=v**v
                        best_success=max(best_success,success)
                        if best_product is None or cell_product<best_product: best_product=cell_product
                        C['assignments']+=1
                    exact_success, exact_product=theoretical(fib.values(),Q)
                    assert best_success==exact_success,('success',n,M,obs,Q)
                    assert best_product==exact_product,('entropy',n,M,obs,Q)
                    C['finite_maps']+=1
        print('FINITE_MAP_N :=',n,'CUMULATIVE :=',C['finite_maps'])

G=tuple(permutations(range(3)))
ID=(0,1,2)
def mul(a,b):return tuple(a[b[i]] for i in range(3))
def inverse(a):return tuple(a.index(i) for i in range(3))
def conjugate(g,a):return mul(mul(g,a),inverse(g))
def cls(a):
    if a==ID:return 0
    return 1 if mul(a,a)==ID else 2

def s3_fibers(k):
    fibers=defaultdict(set)
    orbits={}
    for x in product(G,repeat=k):
        canonical=min(tuple(conjugate(g,a) for a in x) for g in G)
        orbits[canonical]=None
        fibers[tuple(map(cls,x))].add(canonical)
    hist=Counter(len(v) for v in fibers.values())
    expected_N=(6**k+2*3**k+3*2**k)//6
    assert len(orbits)==expected_N
    assert len(fibers)==3**k
    assert sum(size*freq for size,freq in hist.items())==expected_N
    return hist, expected_N, 3**k

def s3_test():
    for k in range(1,5):
        hist,N,M=s3_fibers(k)
        fib=[s for s,count in sorted(hist.items()) for _ in range(count)]
        print('S3_LOOPS :=',k,'GLOBAL_CLASSES :=',N,'SIGNATURES :=',M,
              'FIBER_HIST :=',','.join(f'{s}:{hist[s]}' for s in sorted(hist)))
        for q in (2,3):
            m_min=0
            while q**m_min<max(fib): m_min+=1
            seq=[]
            for m in range(m_min+1):
                good=theoretical(fib,q**m)[0]
                seq.append(f'{good}/{N}')
            assert seq[-1]==f'{N}/{N}'
            print('S3_QARY :=',q,'LOOPS :=',k,'MIN_QUERIES :=',m_min,'BEST_SUCCESS :=',','.join(seq))
        C['s3_families']+=1

def main():
    assert __debug__
    print('PYTHON :=',platform.python_version(),'GUARD_SECONDS :=',TIME_LIMIT)
    finite_test()
    s3_test()
    for k in sorted(C): print(k.upper(),':=',C[k])
    print('FINITE_FIBER_SPECTRUM := COMPUTATION_PASS (bounded)')
    print('LEAN := NOT_RUN; REPO_MODIFIED := NO')
if __name__=='__main__':
    try:main()
    except TimeoutError as e:print(str(e),file=sys.stderr);sys.exit(2)
