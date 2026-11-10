#!/usr/bin/env python3
"""URF finite gauge -> locality/information transfer: independent finite oracle.

Reference for integration: chronos-urf-rr PR #1338 at
b0fd6ef97cf0b73658ad7067d0272084c2d60622, especially
urf_ai.benchmark.cycle_witness and conservative proof-state classifier.

This script is a separate exact-arithmetic verifier, NOT a Lean proof.
No downloads, mutation of repositories, or external dependencies.
"""
from __future__ import annotations
import argparse
import itertools
import json
import time
from collections import Counter, deque
from pathlib import Path


def check_prime(p):
    if type(p) is not int or p < 2 or any(p % q == 0 for q in range(2, int(p ** .5)+1)):
        raise ValueError('p must be prime')


def graph(n, edge_pairs):
    if type(n) is not int or not (1 <= n <= 20):
        raise ValueError('1 <= number of vertices <= 20')
    edges=tuple(sorted(set(tuple(sorted(e)) for e in edge_pairs)))
    if any(len(e)!=2 or e[0]==e[1] or e[0]<0 or e[1]>=n for e in edges):
        raise ValueError('invalid finite simple graph')
    return (n,edges)


def cycle(n):
    if n < 3: raise ValueError('cycle length >= 3')
    return graph(n,[(i,(i+1)%n) for i in range(n)])


def adjacency(vertices, edges):
    adj={u:[] for u in vertices}
    for i,(u,v) in enumerate(edges):
        if u not in adj or v not in adj:raise ValueError('edge outside vertex set')
        adj[u].append((v,i,+1));adj[v].append((u,i,-1))
    for u in adj: adj[u].sort()
    return adj


def spanning_forest(vertices, edges):
    """Exact deterministic spanning forest: edge indices selected as tree edges."""
    adj=adjacency(vertices,edges)
    seen=set();tree=set()
    for root in sorted(vertices):
        if root in seen: continue
        seen.add(root); q=deque([root])
        while q:
            u=q.popleft()
            for v,i,_ in adj[u]:
                if v not in seen:
                    seen.add(v);tree.add(i);q.append(v)
    return tree


def gauge_class(vertices, edges, labels, p):
    """Canonical chord residues after gauging spanning forest edges to zero."""
    if len(edges)!=len(labels):raise ValueError('label size')
    tree=spanning_forest(vertices,edges);adj=adjacency(vertices,edges)
    potential={}
    for root in sorted(vertices):
        if root in potential:continue
        potential[root]=0;q=deque([root])
        while q:
            u=q.popleft()
            for v,i,sgn in adj[u]:
                if i in tree and v not in potential:
                    # labelled oriented edge u->v contributes sgn*labels[i]
                    potential[v]=(potential[u]-sgn*labels[i])%p
                    q.append(v)
    assert len(potential)==len(vertices)
    return tuple((labels[i]+potential[v]-potential[u])%p for i,(u,v) in enumerate(edges) if i not in tree)


def balls(n,edges,r):
    if type(r) is not int or r < 0: raise ValueError('radius must be nonnegative integer')
    a=adjacency(range(n),edges)
    result=[]
    for v in range(n):
        dist={v:0};q=deque([v])
        while q:
            u=q.popleft()
            if dist[u]==r:continue
            for w,_,_ in a[u]:
                if w not in dist:dist[w]=dist[u]+1;q.append(w)
        s=set(dist)
        result.append((tuple(sorted(s)),tuple(i for i,(u,w) in enumerate(edges) if u in s and w in s)))
    return result


def observe(n,edges,labels,p,r):
    return tuple(gauge_class(vs,tuple(edges[i] for i in ids),tuple(labels[i] for i in ids),p)
                 for vs,ids in balls(n,edges,r))


def linear_rank_mod_p(matrix,p):
    if not matrix:return 0
    a=[list(row) for row in matrix];cols=len(a[0]);rows=len(a)
    assert all(len(row)==cols for row in a)
    rank=0
    for col in range(cols):
        pivot=next((i for i in range(rank,rows) if a[i][col]%p),None)
        if pivot is None:continue
        a[rank],a[pivot]=a[pivot],a[rank]
        factor=pow(a[rank][col]%p,-1,p)
        a[rank]=[(t*factor)%p for t in a[rank]]
        for i in range(rows):
            if i!=rank and a[i][col]%p:
                k=a[i][col]
                a[i]=[(u-k*v)%p for u,v in zip(a[i],a[rank])]
        rank+=1
        if rank==rows:break
    return rank


def linear_observation(n,edges,p,r):
    """Quotient-to-quotient observation matrix, global chord coordinates -> local chord coordinates."""
    check_prime(p)
    tree=spanning_forest(range(n),edges)
    chords=[i for i in range(len(edges)) if i not in tree]
    target=[]
    for i in chords:
        labels=[0]*len(edges);labels[i]=1
        target.append(tuple(k for part in observe(n,edges,labels,p,r) for k in part))
    if not target:
        return dict(b1=0,rank=0,kernel=0,obs_rows=0)
    rows=list(zip(*target))
    rank=linear_rank_mod_p(rows,p)
    return dict(b1=len(chords),rank=rank,kernel=len(chords)-rank,obs_rows=len(rows))


def independent_fiber_oracle(n,edges,p,r,limit=200000):
    """Independent exhaustive quotient fiber count; no matrix-rank calls."""
    check_prime(p)
    tree=spanning_forest(range(n),edges)
    chords=[i for i in range(len(edges)) if i not in tree]
    if p**len(chords)>limit:raise ValueError('finite state limit exceeded (INCOMPLETE)')
    counts=Counter()
    for coord in itertools.product(range(p),repeat=len(chords)):
        values=[0]*len(edges)
        for j,x in zip(chords,coord):values[j]=x
        counts[observe(n,edges,values,p,r)]+=1
    return dict(classes=p**len(chords),observations=len(counts),fiber_sizes=sorted(set(counts.values())),
                total=sum(counts.values()))


def direct_gauge_orbit_check(n, edges, p):
    """Third algorithm: explicit gauge action, independent of rank and fiber maps."""
    groups={}
    for labels in itertools.product(range(p),repeat=len(edges)):
        key=gauge_class(range(n),edges,labels,p)
        groups.setdefault(key,set()).add(labels)
    for label_class,actual_members in groups.items():
        representative=min(actual_members)
        orbit=set()
        for g in itertools.product(range(p),repeat=n):
            transformed=tuple((x+g[v]-g[u])%p for x,(u,v) in zip(representative,edges))
            orbit.add(transformed)
        assert orbit==actual_members,('GAUGE_ORBIT_MISMATCH',n,edges,p,label_class)
    return len(groups)


def audit(max_cycle=15, exhaust_small=True, seconds=35):
    start=time.monotonic();checks=0;cases=[]
    for n in range(3,max_cycle+1):
        nn,edges=cycle(n)
        for p in (2,3,5):
            for r in range(n//2+2):
                if time.monotonic()-start>seconds:raise TimeoutError('TIME_GUARD: INCOMPLETE')
                x=linear_observation(nn,edges,p,r)
                expect=0 if r<n//2 else 1
                assert x['b1']==1 and x['rank']==expect and x['kernel']==1-expect,(n,p,r,x)
                # Different algorithm: enumerate one value per global holonomy class.
                y=independent_fiber_oracle(nn,edges,p,r)
                assert y['classes']==p and y['observations']==p**expect and y['fiber_sizes']==[p**(1-expect)]
                checks+=1
                if r in (n//2-1,n//2):
                    cases.append(dict(n=n,p=p,r=r,diameter=n//2,rank=x['rank'],hidden_dimensions=x['kernel'],
                                      global_classes=y['classes'],observation_classes=y['observations'],
                                      max_uniform_success=f'1/{p}' if x['kernel'] else '1'))
    graphs_checked=0;graph_radius_checks=0;gauge_orbits_checked=0
    if exhaust_small:
        for n in range(2,5):
            all_edges=list(itertools.combinations(range(n),2))
            for bits in itertools.product((0,1),repeat=len(all_edges)):
                nn,edges=graph(n,[e for e,bit in zip(all_edges,bits) if bit])
                # All graphs accepted; disconnected graphs also satisfy quotient linearity.
                graphs_checked+=1
                if direct_gauge_orbit_check(nn,edges,2) >= 1:
                    gauge_orbits_checked+=1
                for p in (2,3):
                    for r in range(n+1):
                        if time.monotonic()-start>seconds:raise TimeoutError('TIME_GUARD: INCOMPLETE')
                        x=linear_observation(nn,edges,p,r)
                        y=independent_fiber_oracle(nn,edges,p,r)
                        assert y['classes']==p**x['b1']
                        assert y['observations']==p**x['rank']
                        assert y['fiber_sizes']==[p**x['kernel']]
                        graph_radius_checks+=1
    selected=[
        ('two_triangles_with_bridge',6,[(0,1),(1,2),(2,0),(2,3),(3,4),(4,5),(5,3)]),
        ('five_cycle_chord',5,[(0,1),(1,2),(2,3),(3,4),(4,0),(0,2)]),
        ('theta_2_3_4',8,[(0,1),(1,7),(0,2),(2,3),(3,7),(0,4),(4,5),(5,6),(6,7)]),
        ('complete5',5,list(itertools.combinations(range(5),2))),
    ]
    adversarial_case_checks=0;multi_cycle_results=[]
    for name,n,edgelist in selected:
        nn,edges=graph(n,edgelist)
        for p in (2,3):
            for r in range(n+1):
                if time.monotonic()-start>seconds:raise TimeoutError('TIME_GUARD: INCOMPLETE')
                x=linear_observation(nn,edges,p,r)
                y=independent_fiber_oracle(nn,edges,p,r)
                assert y['classes']==p**x['b1'] and y['observations']==p**x['rank']
                assert y['fiber_sizes']==[p**x['kernel']]
                adversarial_case_checks+=1
                multi_cycle_results.append({'graph':name,'p':p,'r':r,'b1':x['b1'],
                                            'visible_dimensions':x['rank'],'hidden_dimensions':x['kernel']})
    return {'result':'COMPUTATION_PASS','type':'independent exact finite oracle, not formal proof','adversarial_case_checks':adversarial_case_checks,
            'multi_cycle_results':multi_cycle_results,'gauge_orbits_checked':gauge_orbits_checked,
            'cycle_check_count':checks,'cycle_boundary_cases':cases,
            'all_graphs_n2_to_n4':graphs_checked,'graph_radius_checks':graph_radius_checks,
            'assumptions':['finite loopless undirected graphs','induced radius-r balls',
                'independent local gauge quotients','p prime; Fp edge cochains',
                'uniform distribution on global gauge classes for entropy/success statements'],
            'limits':{'max_cycle':max_cycle,'p':[2,3,5], 'graph_n_range':[2,4],
                      'finite_state_cap':200000,'seconds':seconds},
            'status':{'general_theorem':'MATHEMATICAL_PROOF_IN_COMPANION_NOTE',
                      'lean':'NOT_RUN','toolkit_actual_execution':'NOT_RUN',
                      'experimental_toolkit_source':'chronos-urf-rr PR 1338 b0fd6ef97cf0b73658ad7067d0272084c2d60622',
                      'cross_repo_import':'NOT_RUN','novelty':'NOT_ESTABLISHED'}}


def main():
    arg=argparse.ArgumentParser();arg.add_argument('--max-cycle',type=int,default=15)
    arg.add_argument('--seconds',type=int,default=35)
    arg.add_argument('--out',type=Path)
    opt=arg.parse_args()
    try: result=audit(max_cycle=opt.max_cycle,seconds=opt.seconds)
    except (AssertionError,TimeoutError,ValueError) as e:
        print(json.dumps({'status':'INCOMPLETE_OR_FAIL','error':repr(e)}));raise
    if opt.out:
        opt.out.write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k not in ('cycle_boundary_cases','multi_cycle_results')},sort_keys=True,indent=2))

if __name__=='__main__': main()