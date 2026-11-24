#!/usr/bin/env python3
"""Independent raw-vertex pebble game cross-check, k<=3 (no symmetry reduction)."""
from itertools import product
from time import monotonic

def pattern(t):
    return tuple(t[i] == t[j] for i in range(len(t)) for j in range(i+1,len(t))) + tuple(x < 0 for x in t)

def states(n,k): return list(product(range(-1,n), repeat=k))

def replace(t,i,x):
    a=list(t);a[i]=x;return tuple(a)

def test(k,n,m,deadline):
    left,right=states(n,k),states(m,k)
    candidates={(a,b) for a in left for b in right if pattern(a)==pattern(b)}
    initial=((-1,)*k,(-1,)*k)
    steps=0
    while True:
        if monotonic()>deadline: raise RuntimeError('INCOMPLETE: time guard')
        kept=set()
        for a,b in candidates:
            if monotonic()>deadline: raise RuntimeError('INCOMPLETE: time guard')
            ok=True
            for i in range(k):
                if not all(any((replace(a,i,x),replace(b,i,y)) in candidates for y in range(m)) for x in range(n)):
                    ok=False;break
                if not all(any((replace(a,i,x),replace(b,i,y)) in candidates for x in range(n)) for y in range(m)):
                    ok=False;break
            if ok: kept.add((a,b))
        if kept==candidates: return initial in kept,len(candidates),steps
        candidates=kept;steps+=1

D=monotonic()+25
for k in range(1,4):
    w,count,steps=test(k,k,k+1,D)
    if not w: raise SystemExit('FAILED positive k='+str(k))
    print('RAW_PAIR_GAME_EQUIV := PASS',k,'winning_states',count,'iterations',steps)
    if k>=2:
        w,count,steps=test(k,k-1,k,D)
        if w: raise SystemExit('FAILED negative k='+str(k))
        print('RAW_PAIR_GAME_SEPARATION := PASS',k,'winning_states',count,'iterations',steps)
print('DIRECT_CROSSCHECK := COMPUTATION_PASS')
