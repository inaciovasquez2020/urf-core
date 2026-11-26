#!/usr/bin/env python3
"""Exact finite checks of rank-overlap bounds and fixed-threshold DNF compilation."""
from itertools import combinations,product
from collections import deque
import signal,sys
signal.signal(signal.SIGALRM,lambda *_:sys.exit('RESULT := INCOMPLETE_TIMEOUT'))
signal.alarm(90)
def rank(xs):
    basis={}
    for x in xs:
        while x:
            i=x.bit_length()-1
            if i in basis:x^=basis[i]
            else:basis[i]=x;break
    return len(basis)
def graph_checks():
    count=0
    for n in range(1,6):
        universe=list(combinations(range(n),2))
        for mask in range(1<<len(universe)):
            edges=[e for i,e in enumerate(universe) if (mask>>i)&1]
            adj=[[] for _ in range(n)]
            for i,(a,b) in enumerate(edges):adj[a].append((b,i));adj[b].append((a,i))
            for R in range(4):
                bases=[];multiplicity=[0]*len(edges)
                for root in range(n):
                    dist={root:0};queue=deque([root]);paths={root:0};tree=set()
                    while queue:
                        u=queue.popleft()
                        if dist[u]==R:continue
                        for v,i in adj[u]:
                            if v not in dist:
                                dist[v]=dist[u]+1;paths[v]=paths[u]^(1<<i);tree.add(i);queue.append(v)
                    local=[]
                    for i,(u,v) in enumerate(edges):
                        if u in dist and v in dist:
                            multiplicity[i]+=1
                            if i not in tree:local.append(paths[u]^paths[v]^(1<<i))
                    assert rank(local)==len(local)
                    bases.append(local)
                cor=rank(x for b in bases for x in b);total=sum(map(len,bases));M=max(multiplicity,default=0)
                assert total<=M*cor and cor<=total,(n,mask,R,cor,total,M)
                count+=1
    return count

def threshold_checks():
    cases=0
    for n in range(9):
        for t in range(n+2):
            terms=[sum(1<<i for i in s) for s in combinations(range(n),t)]
            for bits in range(1<<n):
                assert any(bits&term==term for term in terms)==(bits.bit_count()>=t)
                cases+=1
    return cases
print('COR_OVERLAP_GRAPH_RADIUS_CASES :=',graph_checks(),'PASS')
print('FIXED_THRESHOLD_TRUTH_TABLE_CASES :=',threshold_checks(),'PASS')
signal.alarm(0)
print('RESULT := COMPUTATION_PASS')
