#!/usr/bin/env python3
"""Independent exact GF(2) adversarial test of PR #597's unrestricted-augmentation
Set Cover construction. Tests are finite evidence, not its general NP-hardness proof.
No repository changes; Python stdlib only; deterministic guards and seed.
"""
from itertools import product, combinations
from collections import Counter
from random import Random
from time import monotonic
import sys, platform

START = monotonic()
LIMIT_SECONDS = 55.0
LIMIT_CASES = 13000
COUNTS = Counter()
RNG = Random(20261123)

def guard():
    if monotonic() - START > LIMIT_SECONDS or COUNTS['augmentations'] >= LIMIT_CASES:
        raise TimeoutError('INCOMPLETE: resource guard exceeded')

def create(U, sets, t):
    m=len(sets); layers=2*t+1
    names=['b']+[f's{j}' for j in range(m)]
    names += [f'{kind}{l}' if kind!='x' else f'x{i}_{l}'
              for l in range(layers) for kind in ('a','z','x')
              for i in (range(U) if kind=='x' else range(1))]
    v={x:i for i,x in enumerate(names)}
    edges=set()
    def add(a,b):
        assert a!=b
        edges.add(tuple(sorted((v[a],v[b]))))
    for i,j in combinations(range(m),2):add(f's{i}',f's{j}')
    for l in range(layers):
        a=f'a{l}'; anchor=f'z{l}'
        add(a,anchor);add('b',anchor)
        for j in range(m):
            add(a,f's{j}');add(anchor,f's{j}')
        for i in range(U):
            x=f'x{i}_{l}'
            add(a,x);add('b',x)
            for j,S in enumerate(sets):
                if i in S:add(x,f's{j}')
    return names,edges

def gf2_rank(rows):
    pivots={}
    for row in rows:
        while row:
            pivot=row.bit_length()-1
            if pivot in pivots:row^=pivots[pivot]
            else:
                pivots[pivot]=row
                break
    return len(pivots)

def h1dimension(n,edges):
    edges=sorted(edges); pos={e:k for k,e in enumerate(edges)}
    adj=[set() for _ in range(n)]
    for a,b in edges:adj[a].add(b);adj[b].add(a)
    seen=set(); comps=0
    for root in range(n):
        if root in seen:continue
        comps+=1; stack=[root]; seen.add(root)
        while stack:
            for w in adj[stack.pop()]:
                if w not in seen:seen.add(w);stack.append(w)
    triangle_vectors=[]
    for i in range(n):
        for j in adj[i]:
            if j<=i:continue
            for k in adj[i]&adj[j]:
                if k<=j:continue
                triangle_vectors.append((1<<pos[(i,j)]) | (1<<pos[(i,k)]) | (1<<pos[(j,k)]))
    cycle_rank=len(edges)-n+comps
    triangle_rank=gf2_rank(triangle_vectors)
    assert 0<=triangle_rank<=cycle_rank
    return cycle_rank-triangle_rank

def has_cover(U,sets,t):
    return any(set(range(U)) <= set().union(*(sets[j] for j in J))
               for k in range(t+1) for J in combinations(range(len(sets)),k))

def verify(U,sets,t,random_pairs=0):
    assert U>=1 and len(sets)>=1 and t>=1
    names,ed=create(U,sets,t)
    n=len(names)
    assert n==1+len(sets)+(2*t+1)*(U+2)
    missing=[(a,b) for a in range(n) for b in range(a+1,n) if (a,b) not in ed]
    expected=has_cover(U,sets,t)
    base=h1dimension(n,ed)
    C=0
    candidates=[()]+[(e,) for e in missing]
    if random_pairs:
        seen=set()
        for _ in range(random_pairs):
            a,b=RNG.sample(missing,2)
            key=tuple(sorted((a,b)))
            if key not in seen:
                seen.add(key);candidates.append(key)
    for A in candidates:
        guard()
        h=h1dimension(n,ed|set(A))
        # explicit extraction instead of relying on construction's provenance
        j=set()
        for a,b in A:
            na,nb=names[a],names[b]
            if na=='b' and nb.startswith('s'):j.add(int(nb[1:]))
            if nb=='b' and na.startswith('s'):j.add(int(na[1:]))
        covers=set(range(U))<=set().union(*(sets[k] for k in j))
        if h==0:assert covers,('false positive',U,sets,t,A,h)
        if not expected:assert h!=0,('unsound',U,sets,t,A,h)
        COUNTS['augmentations']+=1
        C+=(h==0)
    if expected:
        for k in range(t+1):
            for J in combinations(range(len(sets)),k):
                if set(range(U))<=set().union(*(sets[j] for j in J)):
                    changed=set(ed)
                    changed|={tuple(sorted((names.index('b'),names.index(f's{j}')))) for j in J}
                    assert h1dimension(n,changed)==0,('forward fails',U,sets,t,J)
                    COUNTS['forward_covers']+=1
    COUNTS['instances']+=1
    COUNTS['successful_augmentations']+=C
    COUNTS['expected_yes']+=int(expected)
    COUNTS['expected_no']+=int(not expected)
    COUNTS['baseline_h1_sum']+=base


def main():
    assert __debug__
    print('PYTHON :=',platform.python_version(),'SEED := 20261123')
    # All multisets of up to two subsets of U, for U=1,2 and t=1.
    for U in (1,2):
        choices=[frozenset(i for i in range(U) if bits&(1<<i)) for bits in range(1<<U)]
        for m in (1,2):
            for S in combinations(range(len(choices)),m) if m <= len(choices) else []:
                verify(U,tuple(choices[j] for j in S),1)
            for S in product(range(len(choices)),repeat=m):
                verify(U,tuple(choices[j] for j in S),1)
    # t=2: pair additions touch at most 4 of 5 layers; adversarial mixed shortcuts.
    verify(2,(frozenset((0,)),frozenset((1,))),2,random_pairs=850)
    verify(2,(frozenset(),frozenset((0,))),2,random_pairs=850)
    verify(2,(frozenset((0,1)),frozenset()),2,random_pairs=850)
    for k in sorted(COUNTS): print(k.upper(),':=',COUNTS[k])
    print('UNRESTRICTED_SET_COVER_REDUCTION_SMALL_EXACT := COMPUTATION_PASS')
    print('NOTE := finite F2 testing only, not NP-completeness proof')

if __name__=='__main__':
    try:main()
    except TimeoutError as e:
        print(str(e),file=sys.stderr);sys.exit(2)
