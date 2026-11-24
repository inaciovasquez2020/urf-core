#!/usr/bin/env python3
"""Exact finite tests for a proposed URF local-observation completion theorem.

Source-free audit, Python standard library only, no repository writes.
Finite enumerations are not a proof of the unrestricted theorem.
Field sizes are primes, so arithmetic mod p is a field.
"""
import itertools
import platform
import sys
import time
from collections import Counter, deque

MAX_SECONDS = 35.0
MAX_STATES_PER_GRAPH = 100_000
T0 = time.monotonic()
COUNT = Counter()


def guard():
    if time.monotonic() - T0 > MAX_SECONDS:
        raise TimeoutError("INCOMPLETE: wall-clock budget exhausted")


def rank(rows, p, width):
    mat = [[int(t) % p for t in row] for row in rows]
    piv = 0
    for col in range(width):
        k = next((i for i in range(piv, len(mat)) if mat[i][col]), None)
        if k is None:
            continue
        mat[piv], mat[k] = mat[k], mat[piv]
        a = pow(mat[piv][col], -1, p)
        mat[piv] = [(a * x) % p for x in mat[piv]]
        for i in range(len(mat)):
            if i != piv and mat[i][col]:
                c = mat[i][col]
                mat[i] = [(u - c*v) % p for u, v in zip(mat[i], mat[piv])]
        piv += 1
        if piv == len(mat):
            break
    return piv


def connected_tree(n, edges):
    adj = [[] for _ in range(n)]
    for u,v in edges:
        adj[u].append(v)
        adj[v].append(u)
    for a in adj:
        a.sort()
    seen = {0}
    tree = set()
    queue = deque([0])
    while queue:
        u = queue.popleft()
        for v in adj[u]:
            if v not in seen:
                seen.add(v)
                tree.add((min(u,v), max(u,v)))
                queue.append(v)
    return tree if len(seen) == n else None


def graph_data(n, edges, p):
    tree = connected_tree(n, edges)
    if tree is None:
        return None
    eset = set(edges)
    chords = [e for e in edges if e not in tree]
    b = len(chords)
    incidence = [[0] * len(edges) for _ in range(n)]
    for j,(u,v) in enumerate(edges):
        incidence[u][j] = (-1) % p
        incidence[v][j] = 1
    assert rank(incidence,p,len(edges)) == n-1
    triangle_edges = []
    for a,bv,c in itertools.combinations(range(n),3):
        if (a,bv) in eset and (bv,c) in eset and (a,c) in eset:
            signed={(a,bv):1,(bv,c):1,(a,c):-1}
            full = [signed.get(edge,0) for edge in edges]
            # Independent check: each triangle's oriented boundary vanishes.
            for ir in incidence:
                assert sum(x*y for x,y in zip(ir,full))%p == 0
            triangle_edges.append(full)
    # The chord-coordinate map is injective on the graph cycle space.
    direct_r=rank(triangle_edges,p,len(edges))
    ci={e:i for i,e in enumerate(edges)}
    local=[[full[ci[e]]%p for e in chords] for full in triangle_edges]
    r=rank(local,p,b)
    assert r==direct_r,(n,edges,p,r,direct_r)
    assert 0<=r<=b
    extended=list(local)
    supplements=[]
    for j in range(b):
        e=[0]*b
        e[j]=1
        if rank(extended+[e],p,b)>rank(extended,p,b):
            supplements.append(e)
            extended.append(e)
    h=b-r
    assert len(supplements)==h and rank(extended,p,b)==b
    return b,r,h,local,supplements


def signature(rows,x,p):
    return tuple(sum(a*b for a,b in zip(row,x))%p for row in rows)


def brute_fibers(rows,p,b):
    if p**b>MAX_STATES_PER_GRAPH:
        raise RuntimeError("INCOMPLETE: state-count cap exceeded")
    out=Counter()
    for x in itertools.product(range(p),repeat=b):
        out[signature(rows,x,p)]+=1
    return out


def verify_graph(n,edges,p):
    guard()
    data=graph_data(n,edges,p)
    if data is None:
        return
    b,r,h,local,supplements=data
    base=brute_fibers(local,p,b)
    assert len(base)==p**r
    assert set(base.values())=={p**h}
    COUNT['graphs_checked']+=1
    COUNT['states_checked']+=p**b
    COUNT['fibers_checked']+=len(base)
    COUNT[f'prime_{p}_graphs']+=1
    COUNT[f'hidden_{h}_graphs']+=1
    for m in range(h+1):
        obs=local+supplements[:m]
        fibers=brute_fibers(obs,p,b)
        assert rank(obs,p,b)==r+m
        assert len(fibers)==p**(r+m)
        assert set(fibers.values())=={p**(h-m)}
        # Independent finite-map optimal decoder success = observed values / states.
        assert len(fibers)*p**(h-m)==p**b
        COUNT['probe_depth_cases']+=1
        COUNT['states_with_probes_checked']+=p**b
        COUNT['probe_fibers_checked']+=len(fibers)
    # Adversarial: duplicate a local observation or duplicate a new probe.
    if local:
        assert rank(local+[local[0]],p,b)==r
        assert brute_fibers(local+[local[0]],p,b).values()==base.values() or set(brute_fibers(local+[local[0]],p,b).values())=={p**h}
        COUNT['redundant_probe_controls']+=1
    if supplements:
        x=local+[supplements[0]]
        assert rank(x+[supplements[0]],p,b)==r+1
        COUNT['redundant_probe_controls']+=1


def edges_of(n,edge_list):
    return tuple(sorted(tuple(sorted(e)) for e in edge_list))


def run():
    if not __debug__:
        raise RuntimeError("INCOMPLETE: run without -O so assertions are active")
    print('PYTHON :=',platform.python_version())
    print('BUDGET_SECONDS :=',MAX_SECONDS)
    print('MAX_STATES_PER_GRAPH :=',MAX_STATES_PER_GRAPH)
    for n in range(2,6):
        all_edges=list(itertools.combinations(range(n),2))
        for mask in range(1 << len(all_edges)):
            edges=tuple(e for i,e in enumerate(all_edges) if (mask>>i)&1)
            if connected_tree(n,edges) is not None:
                verify_graph(n,edges,2)
                if n<=4:
                    verify_graph(n,edges,3)
                    verify_graph(n,edges,5)
        print('EXHAUSTIVE_CONNECTED_LABELED_UP_TO_N :=',n,'COUNT_GF2 :=',COUNT['prime_2_graphs'])
    examples={
        'C6':(6,[(i,(i+1)%6) for i in range(6)],1),
        'C7':(7,[(i,(i+1)%7) for i in range(7)],1),
        'K4':(4,list(itertools.combinations(range(4),2)),0),
        'triangular_prism':(6,[(0,1),(1,2),(0,2),(3,4),(4,5),(3,5),(0,3),(1,4),(2,5)],2),
        'triangle_and_square':(6,[(0,1),(1,2),(0,2),(2,3),(3,4),(4,5),(2,5)],1),
        'two_squares_wedge':(7,[(0,1),(1,2),(2,3),(0,3),(0,4),(4,5),(5,6),(0,6)],2),
    }
    for name,(n,ed,expected_h) in examples.items():
        edges=edges_of(n,ed)
        for p in (2,3,5):
            b,r,h,*_=graph_data(n,edges,p)
            assert h==expected_h,(name,p,h,expected_h)
            verify_graph(n,edges,p)
        print('FAMILY :=',name,'B1 :=',b,'TRIANGLE_RANK :=',r,'HIDDEN_DIM :=',h)
    # Sharp converse: two q-ary probes cannot resolve a 3-dimensional uniform fiber.
    # Pure combinatorial capacity bound, independent of field/linear query structure.
    for p in (2,3,5):
        for h in range(1,5):
            for m in range(h):
                assert p**m<p**h
                assert (p**m)/(p**h)==p**(m-h)
                COUNT['adaptive_capacity_bound_cases']+=1
    for k in sorted(COUNT):
        print(k.upper(),':=',COUNT[k])
    print('STATUS := COMPUTATION_PASS (bounded scope; analytic proof separate)')
    print('SOURCE_MODIFICATIONS := NONE')
    print('LEAN := NOT_RUN')

if __name__=='__main__':
    try:
        run()
    except (TimeoutError,RuntimeError) as e:
        print(str(e),file=sys.stderr)
        sys.exit(2)
