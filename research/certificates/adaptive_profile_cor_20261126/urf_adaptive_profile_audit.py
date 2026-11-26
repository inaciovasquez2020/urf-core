#!/usr/bin/env python3
"""Exact exhaustive comparison of optimal decision trees with the dual-rank profile.
Prime fields only in this finite test; mathematical statement holds for prime powers.
"""
from itertools import product, combinations
from functools import lru_cache
from fractions import Fraction
import signal, sys
signal.signal(signal.SIGALRM, lambda *_: sys.exit('RESULT := INCOMPLETE_TIMEOUT'))
signal.alarm(90)

def check(p,m):
    points=list(product(range(p),repeat=m)); n=len(points); ix={x:i for i,x in enumerate(points)}
    adds=[[ix[tuple((a+b)%p for a,b in zip(x,y))] for y in points] for x in points]
    multiples=[[ix[tuple((a*t)%p for a in x)] for t in range(p)] for x in points]
    codes={frozenset([0])}; frontier=list(codes)
    while frontier:
        u=frontier.pop()
        for x in range(n):
            if x in u: continue
            v=frozenset(adds[y][z] for y in u for z in multiples[x])
            if v not in codes: codes.add(v);frontier.append(v)
    masks=[[sum(1<<i for i,x in enumerate(points) if x[j]==v) for v in range(p)] for j in range(m)]
    whole=(1<<n)-1; checks=0; proper=0
    for u in codes:
        if len(u)==n:continue
        proper+=1; a=len(u); b=n-a; ub=sum(1<<i for i in u)
        @lru_cache(None)
        def opt(cell,avail,k):
            a0=(cell&ub).bit_count(); b0=cell.bit_count()-a0
            stop=max(a0*b,b0*a)
            if not k or not a0 or not b0:return stop
            return max([stop]+[sum(opt(cell&mask,avail^(1<<j),k-1) for mask in masks[j]) for j in range(m) if avail>>j&1])
        # Compute the supported dual dimension directly by enumerating dual vectors.
        dual=[x for x in points if all(sum(c*d for c,d in zip(x,points[y]))%p==0 for y in u)]
        for k in range(m+1):
            largest=max(sum(all(x[j]==0 for j in range(m) if j not in s) for x in dual) for s in combinations(range(m),k))
            assert largest and len(dual)*a==n
            expected=(1+Fraction(1-Fraction(1,largest),1-Fraction(a,n)))/2
            actual=Fraction(opt(whole,(1<<m)-1,k),2*a*b)
            assert expected==actual,(p,m,u,k,expected,actual)
            checks+=1
        opt.cache_clear()
    print(f'FIELD={p} DIM={m} SUBSPACES={len(codes)} PROPER={proper} BUDGET_CHECKS={checks} PASS')
    return proper,checks

if __name__=='__main__':
    a=b=0
    for p,M in [(2,5),(3,4),(5,2)]:
        for m in range(1,M+1):
            u,v=check(p,m);a+=u;b+=v
    print('PROPER_SUBSPACES :=',a)
    print('EXACT_BUDGET_CHECKS :=',b)
    signal.alarm(0)
    print('RESULT := COMPUTATION_PASS')
