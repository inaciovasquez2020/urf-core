#!/usr/bin/env python3
"""Bounded, deterministic exact verification. Python stdlib only; no repo writes."""
import collections as C, functools as F, itertools as I, math, signal, sys, time
from fractions import Fraction as Q
signal.signal(signal.SIGALRM, lambda *_: sys.exit('RESULT := INCOMPLETE_TIMEOUT'))
signal.alarm(90)
def rank(vs):
    piv={}
    for v in vs:
        while v:
            k=v.bit_length()-1
            if k in piv:v^=piv[k]
            else:piv[k]=v;break
    return len(piv)
def graph_cor(n,edges,r):
    adj=[[] for _ in range(n)]
    for i,(a,b) in enumerate(edges):adj[a].append((b,i));adj[b].append((a,i))
    vectors=[]
    for root in range(n):
        dist={root:0};path={root:0};q=C.deque([root])
        while q:
            a=q.popleft()
            if dist[a]==r:continue
            for b,i in adj[a]:
                if b not in dist:dist[b]=dist[a]+1;path[b]=path[a]^(1<<i);q.append(b)
        for a in dist:
            for b,i in adj[a]:
                if a<b and b in dist:vectors.append(path[a]^path[b]^(1<<i))
    return rank(vectors)
checks=0
for m in range(3,81):
    edges=sorted({tuple(sorted((3*i+j,3*((i+1)%m)+j))) for i in range(m) for j in range(3)}|{(3*i+j,3*i+k) for i in range(m) for j in range(3) for k in range(j+1,3)})
    for r in range(5):
        expected=0 if r==0 else (6 if m==3 else m) if r==1 else 3*m+(m<=2*r+1)
        actual=graph_cor(3*m,edges,r)
        assert actual==expected,(m,r,actual,expected)
        checks+=1
print('COR_EXACT_SPECTRUM_CHECKS :=',checks, 'PASS',flush=True)
# Exhaustive labeled subspaces through dimension five, independently enumerate by closure.
spaces_count=projection_checks=decision_checks=0
for m in range(1,6):
    full=frozenset(range(1<<m));spaces={frozenset({0})};front=list(spaces)
    while front:
        u=front.pop()
        for v in full-u:
            s=u|frozenset(x^v for x in u)
            if s not in spaces:spaces.add(s);front.append(s)
    for u in spaces:
        spaces_count+=1
        dual=[v for v in full if all((v&x).bit_count()%2==0 for x in u)]
        support=F.reduce(int.__or__,dual,0)
        @F.lru_cache(None)
        def opt(mask,value):
            pts=[x for x in full if x&mask==value]
            if all(x in u for x in pts) or all(x not in u for x in pts):return 0
            return 1+min(max(opt(mask|b,value),opt(mask|b,value|b)) for b in (1<<i for i in range(m)) if not mask&b)
        assert opt(0,0)==support.bit_count(),(m,u,dual)
        decision_checks+=1
        if u==full:continue
        d=min(v.bit_count() for v in dual if v)
        differing=[]
        for mask in full:
            a=C.Counter(x&mask for x in u);b=C.Counter(x&mask for x in full-u)
            equal=all(a[z]*len(full-u)==b[z]*len(u) for z in a.keys()|b.keys())
            if not equal:differing.append(mask.bit_count())
            if mask.bit_count()<d:assert equal,(m,u,mask)
            projection_checks+=1
        assert min(differing)==d
print('BINARY_SUBSPACES :=',spaces_count,'PASS',flush=True)
print('CLASS_MARGINAL_COMPARISONS :=',projection_checks,'PASS',flush=True)
print('EXACT_DECISION_TREE_DP :=',decision_checks,'PASS',flush=True)
# Exact entropy arithmetic: encode N*H as coefficients of log primes, no floats.
def fac(n):
    out=C.Counter();k=2
    while k*k<=n:
        while n%k==0:out[k]+=1;n//=k
        k+=1
    if n>1:out[n]+=1
    return out
def add(*terms):
    d=C.Counter()
    for s,t in terms:
        for k,v in t.items():d[k]+=s*v
    return {k:v for k,v in d.items() if v}
def h(rows,idx):
    counts=C.Counter(tuple(row[i] for i in idx) for row in rows);n=len(rows)
    return add((n,fac(n)),*((-v,fac(v)) for v in counts.values()))
def cond(rows,a,b):return add((1,h(rows,a+b)),(-1,h(rows,b)))
# A=C_t,B=C_{t+1}, Z=old transcript, W=new observation; new prefix=(Z,W).
vals=list(I.product(range(2),repeat=4));echecks=0
for ids in I.combinations_with_replacement(range(16),4):
    rows=[vals[i] for i in ids]
    lhs=add((1,cond(rows,(0,),(2,))),(-1,cond(rows,(1,),(2,3))))
    rhs=add((1,cond(rows,(0,),(2,))),(-1,cond(rows,(0,),(2,3))),(1,cond(rows,(0,),(1,2,3))),(-1,cond(rows,(1,),(0,2,3))))
    assert lhs==rhs,(ids,lhs,rhs)
    echecks+=1
print('EXACT_ENTROPY_IDENTITY_DISTRIBUTIONS :=',echecks,'PASS',flush=True)
# Verify graph packing lower bound on every labeled graph up to five vertices, radius 1 and 2.
packchecks=0
for n in range(1,6):
    all_edges=list(I.combinations(range(n),2))
    for bits in range(1<<len(all_edges)):
        edges=[e for i,e in enumerate(all_edges) if bits>>i&1]
        adj=[set() for _ in range(n)]
        for a,b in edges:adj[a].add(b);adj[b].add(a)
        def ball(a,r):
            s={a}
            for _ in range(r):s=s|set().union(*(adj[x] for x in s))
            return s
        for r in (1,2):
            bs=[ball(a,r) for a in range(n)]
            s=sum(sum(a in b and c in b for a,c in edges)>=len(b) for b in bs)
            M=max(len(ball(a,2*r)) for a in range(n))
            assert graph_cor(n,edges,r)>=(s+M-1)//M
            packchecks+=1
print('EXHAUSTIVE_PACKING_GRAPH_RADIUS_CASES :=',packchecks,'PASS',flush=True)
# Independent exact graph-coloring vs covering schedules by set-cover DP.
colorchecks=0
for n in range(1,6):
    es=list(I.combinations(range(n),2));full=(1<<n)-1
    for bits in range(1<<len(es)):
        a=[0]*n
        for i,(x,y) in enumerate(es):
            if bits>>i&1:a[x]|=1<<y;a[y]|=1<<x
        for r in (0,1,2):
            p=[]
            for x in range(n):
                reach=1<<x
                for _ in range(2*r):reach|=F.reduce(int.__or__,(a[j] for j in range(n) if reach>>j&1),0)
                p.append(reach^(1<<x))
            indep=[s for s in range(1,full+1) if all(not(s>>j&1 and p[j]&s) for j in range(n))]
            @F.lru_cache(None)
            def cover(s):
                if not s:return 0
                return 1+min(cover(s&~i) for i in indep if i&s)
            colors=[]
            def color(j,k):
                if j==n:return True
                for c in range(k):
                    if all(not(p[j]>>i&1) or colors[i]!=c for i in range(j)):
                        colors.append(c)
                        if color(j+1,k):colors.pop();return True
                        colors.pop()
                return False
            chi=next(k for k in range(1,n+1) if color(0,k))
            assert chi==cover(full)
            colorchecks+=1
print('POWER_GRAPH_COLOR_COVER_CASES :=',colorchecks,'PASS',flush=True)
signal.alarm(0)
print('RESULT := COMPUTATION_PASS')
