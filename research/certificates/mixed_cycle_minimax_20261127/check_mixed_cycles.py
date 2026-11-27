"""Independent bounded check, no Lean. Python 3 + NetworkX.
Enumerate every unordered partition into cycles for 3 <= N <= 24.
Compute rooted induced balls via BFS and rooted graph isomorphism; verify
actual signed incidence rank over GF(2) and GF(3), and exact normalized errors.
"""
from collections import Counter, defaultdict
from functools import lru_cache
from fractions import Fraction
import json, platform, time
import networkx as nx

START = time.monotonic()
MAX_SECONDS = 60
MAX_INSTANCES = 100000

def guard():
    if time.monotonic() - START > MAX_SECONDS:
        raise SystemExit('INCOMPLETE: time guard')

def partitions(n, minimum=3):
    if n == 0:
        yield ()
    for k in range(minimum, n+1):
        if n-k == 0 or n-k >= k:
            for rest in partitions(n-k, k):
                yield (k,) + rest

def rank_mod(rows, p):
    rows = [list(row) for row in rows]
    k = 0
    for col in range(len(rows[0])):
        i = next((i for i in range(k,len(rows)) if rows[i][col] % p),None)
        if i is None: continue
        rows[k],rows[i] = rows[i],rows[k]
        inv = pow(rows[k][col] % p,-1,p)
        rows[k] = [x*inv%p for x in rows[k]]
        for i in range(k+1,len(rows)):
            a = rows[i][col]%p
            if a: rows[i] = [(x-a*y)%p for x,y in zip(rows[i],rows[k])]
        k += 1
        if k==len(rows): break
    return k

reps=[]
@lru_cache(None)
def component_deck(t,r):
    g=nx.cycle_graph(t)
    result=Counter()
    for u in g:
        guard()
        v=nx.single_source_shortest_path_length(g,u,cutoff=r)
        ball=g.subgraph(v).copy()
        nx.set_node_attributes(ball,{x:x==u for x in ball},'root')
        match=next((i for i,h in enumerate(reps) if len(h)==len(ball) and h.number_of_edges()==ball.number_of_edges() and nx.is_isomorphic(h,ball,node_match=lambda a,b:a['root']==b['root'])),None)
        if match is None:
            match=len(reps); reps.append(ball)
        result[match]+=1
    return result

parts_count=rank_checks=instances=decks_checked=parameter_triples=family_instances=0
for N in range(3,25):
    ps=list(partitions(N))
    for sizes in ps:
        guard(); parts_count+=1
        g=nx.disjoint_union_all([nx.cycle_graph(t) for t in sizes])
        edges=list(g.edges()); rows=[[int(v==b)-int(v==a) for a,b in edges] for v in g]
        for p in (2,3):
            assert len(edges)-rank_mod(rows,p)==len(sizes), (N,sizes,p)
            rank_checks+=1
    for r in range(0, N//2+1):
        T=max(3,2*r+2)
        records=[]
        for sizes in ps:
            guard(); instances+=1
            if instances>MAX_INSTANCES: raise SystemExit('INCOMPLETE: instance guard')
            d=Counter()
            for t in sizes: d.update(component_deck(t,r))
            M=sum(c for i,c in d.items() if nx.is_forest(reps[i]))
            assert M==sum(t for t in sizes if t>=T)
            records.append((min(sizes),tuple(sorted(d.items())),len(sizes),M))
        for L in range(3,N+1):
            parameter_triples+=1; groups=defaultdict(list)
            for lo,d,k,M in records:
                if lo>=L: groups[d].append((k,M));family_instances+=1
            D=max(L,T); worst=Fraction(0)
            for d,vals in groups.items():
                decks_checked+=1
                ks={k for k,M in vals}; ms={M for k,M in vals}
                assert len(ms)==1
                M=next(iter(ms))
                rad=Fraction(max(ks)-min(ks),2)
                assert rad==Fraction(max(0,M//D-1),2),(N,L,r,d,rad,M)
                worst=max(worst,rad)
            assert worst==Fraction(max(0,N//D-1),2),(N,L,r,worst)
print(json.dumps(dict(status='COMPUTATION_PASS',N_range=[3,24],radius_range='0..floor(N/2)',fields=[2,3],python=platform.python_version(),networkx=nx.__version__,unordered_partitions=parts_count,signed_rank_checks=rank_checks,partition_radius_instances=instances,family_parameter_triples=parameter_triples,family_instances=family_instances,deck_checks=decks_checked,mismatches=0,seconds=round(time.monotonic()-START,3)),indent=2))
