#!/usr/bin/env python3
"""Independent certificate for the cycle-span criterion of the URF transfer.

The observed local gauges are independent; this audits the dual graph-cycle
formulation independently of the global-gauge quotient implementation.
All arithmetic is exact and bounded. No Lean proof or toolkit invocation.
"""
from __future__ import annotations
import argparse
import hashlib
import itertools
import json
import time
from collections import deque
from pathlib import Path

from urf_cross_domain_transfer_20261109 import (graph, cycle, balls, linear_observation,
    linear_rank_mod_p, spanning_forest, check_prime)


def fundamental_cycles(vertex_set, edge_ids, all_edges, p):
    """One global-edge-coordinate cycle for each nonforest edge of the subgraph."""
    verts=tuple(sorted(vertex_set))
    ids=tuple(edge_ids)
    edges=tuple(all_edges[i] for i in ids)
    forest=spanning_forest(verts,edges)
    tadj={v:[] for v in verts}
    for local_i,(u,v) in enumerate(edges):
        if local_i in forest:
            gidx=ids[local_i]
            tadj[u].append((v,gidx,1))
            tadj[v].append((u,gidx,-1))
    cycles=[]
    for local_i,(u,v) in enumerate(edges):
        if local_i in forest:continue
        global_i=ids[local_i]
        # Cycle = non-tree edge u->v followed by the unique tree path v->u.
        q=deque([v]); prev={v:None}
        while q and u not in prev:
            a=q.popleft()
            for b,j,sgn in tadj[a]:
                if b not in prev:
                    prev[b]=(a,j,sgn);q.append(b)
        if u not in prev:raise AssertionError('spanning-forest chord without tree path')
        z=[0]*len(all_edges);z[global_i]=1
        cur=u
        while cur!=v:
            a,j,sgn=prev[cur]
            z[j]=(z[j]+sgn)%p
            cur=a
        # Independent certificate: oriented incidence boundary must vanish.
        boundary=[0]*(1+max(max(verts,default=0), max((v for e in all_edges for v in e), default=0)))
        for j,(a,b) in enumerate(all_edges):
            boundary[a]=(boundary[a]-z[j])%p
            boundary[b]=(boundary[b]+z[j])%p
        if any(boundary):raise AssertionError(('invalid-cycle-boundary',z,p))
        cycles.append(z)
    return cycles


def observed_cycle_span(n, edges, p, r):
    """Compute rank of actual embedded local cycles, not quotient observations."""
    check_prime(p)
    vectors=[];counts=[]
    for verts,ids in balls(n,edges,r):
        basis=fundamental_cycles(verts,ids,edges,p)
        vectors.extend(basis)
        counts.append(len(basis))
    total_cycles=len(edges)-n+len({find_component(x,n,edges) for x in range(n)})
    rank=linear_rank_mod_p(vectors,p)
    return dict(b1=total_cycles,rank=rank,kernel=total_cycles-rank,
        local_basis_vector_count=len(vectors),local_cycle_counts=counts)


def find_component(v,n,edges):
    adj={i:[] for i in range(n)}
    for a,b in edges:adj[a].append(b);adj[b].append(a)
    seen={v};q=deque([v])
    while q:
        a=q.popleft()
        for b in adj[a]:
            if b not in seen:seen.add(b);q.append(b)
    return min(seen)


def audit(seconds=35):
    begin=time.monotonic()
    counts={'cycle_cases':0,'all_graphs':0,'all_graph_observations':0,'adversarial_observations':0}
    nontrivial=[]
    def check(n,edges,p,r,name):
        if time.monotonic()-begin>seconds:raise TimeoutError('TIME_GUARD := INCOMPLETE')
        a=linear_observation(n,edges,p,r)
        b=observed_cycle_span(n,edges,p,r)
        if (a['b1'],a['rank'],a['kernel']) != (b['b1'],b['rank'],b['kernel']):
            raise AssertionError((name,n,edges,p,r,a,b))
        if a['rank']>a['b1'] or a['kernel']<0:raise AssertionError('invalid-rank')
        return a,b
    for n in range(3,21):
        nn,edges=cycle(n)
        for p in (2,3,5,7):
            for r in range(n//2+2):
                a,b=check(nn,edges,p,r,'cycle')
                if (r>=n//2)!=(a['rank']==1):raise AssertionError('sharp-cycle-boundary')
                counts['cycle_cases']+=1
    for n in range(2,5):
        all_edges=list(itertools.combinations(range(n),2))
        for mask in range(1<<len(all_edges)):
            nn,edges=graph(n,[e for i,e in enumerate(all_edges) if (mask>>i)&1])
            counts['all_graphs']+=1
            for p in (2,3,5):
                for r in range(n+1):
                    check(nn,edges,p,r,'all_graph')
                    counts['all_graph_observations']+=1
    target=[
        ('bridge_triangles',6,[(0,1),(1,2),(2,0),(2,3),(3,4),(4,5),(5,3)]),
        ('chorded_cycle',5,[(0,1),(1,2),(2,3),(3,4),(4,0),(0,2)]),
        ('theta',8,[(0,1),(1,7),(0,2),(2,3),(3,7),(0,4),(4,5),(5,6),(6,7)]),
        ('complete5',5,list(itertools.combinations(range(5),2)))
    ]
    for name,n,ed in target:
        nn,edges=graph(n,ed)
        for p in (2,3,5):
            for r in range(n+1):
                a,b=check(nn,edges,p,r,name)
                counts['adversarial_observations']+=1
                if a['rank']>0 and a['kernel']>0 and len(nontrivial)<20:
                    nontrivial.append({'name':name,'p':p,'r':r,'b1':a['b1'],
                        'visible':a['rank'],'hidden':a['kernel'],
                        'local_basis_vectors':b['local_basis_vector_count']})
    return {'result':'COMPUTATION_PASS','method':'independent fundamental-cycle span versus quotient restriction rank',
        'counts':counts,'partial_observation_examples':nontrivial,
        'theorem':'rank of local quotient observations equals dimension of span of embedded local cycle spaces',
        'boundaries':['finite simple undirected graphs','F_p for p prime',
            'independent gauge quotient per local induced ball','no global overlap synchronization',
            'finite check only; not Lean verification'],'seconds_guard':seconds,
        'toolkit':'NOT_RUN','lean':'NOT_RUN','novelty':'NOT_ESTABLISHED'}


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--seconds',type=int,default=35)
    ap.add_argument('--out',type=Path)
    cfg=ap.parse_args()
    try: res=audit(cfg.seconds)
    except (AssertionError, ValueError, TimeoutError) as exc:
        print(json.dumps({'result':'INCOMPLETE_OR_FAIL','error':repr(exc)}));raise
    encoded=(json.dumps(res,sort_keys=True,indent=2)+'\n').encode()
    if cfg.out:cfg.out.write_bytes(encoded)
    print(json.dumps({k:v for k,v in res.items() if k!='partial_observation_examples'},sort_keys=True,indent=2))
    print('RECEIPT_SHA256 :=',hashlib.sha256(encoded).hexdigest())

if __name__=='__main__':main()
