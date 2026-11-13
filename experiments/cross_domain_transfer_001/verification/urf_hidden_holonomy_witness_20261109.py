#!/usr/bin/env python3
"""Constructive certificates for URF Transfer 001 (Python stdlib, read-only).

For each finite graph/p/r, construct a basis of globally inequivalent edge
cochains whose restriction to EVERY induced radius-r ball is locally gauge
trivial. Produce independent local vertex potentials for every certificate.

Mathematical scope: simple undirected finite graphs with fixed edge orientation,
Fp for prime p, independent gauge quotients on induced balls. This is bounded
computational evidence, NOT Lean/kernel proof or unrestricted locality claim.
"""
from __future__ import annotations
import argparse, hashlib, itertools, json, time
from pathlib import Path
from urf_cross_domain_transfer_20261109 import graph, cycle, balls, linear_rank_mod_p, check_prime
from urf_cycle_span_transfer_20261109 import fundamental_cycles


def row_basis(vectors, p):
    out=[]
    for vec in vectors:
        if linear_rank_mod_p(out+[vec],p) > len(out):
            out.append(list(vec))
    return out


def solve_full_row_rank(rows, b, n, p):
    """Solve A*x=b over Fp with a free-variables-zero canonical solution.

    Requires row independence. Return a length-n vector; independently
    recheck every original equation before releasing result.
    """
    if len(rows)!=len(b) or any(len(v)!=n for v in rows):
        raise ValueError('shape mismatch')
    m=len(rows)
    a=[[w%p for w in row]+[v%p] for row,v in zip(rows,b)]
    pivots=[]
    for col in range(n):
        if len(pivots)==m:break
        k=len(pivots)
        j=next((i for i in range(k,m) if a[i][col]),None)
        if j is None: continue
        a[j],a[k]=a[k],a[j]
        inv=pow(a[k][col],-1,p)
        a[k]=[(x*inv)%p for x in a[k]]
        for i in range(m):
            if i!=k and a[i][col]:
                q=a[i][col]
                a[i]=[(x-q*y)%p for x,y in zip(a[i],a[k])]
        pivots.append(col)
    if len(pivots)!=m:raise AssertionError('rows not independent')
    x=[0]*n
    for i,col in enumerate(pivots):x[col]=a[i][-1]
    if any(sum(u*v for u,v in zip(row,x))%p!=target%p for row,target in zip(rows,b)):
        raise AssertionError('linear solve certificate rejected')
    return x


def local_potential(vertices, edges, labels, p):
    """Return g with every a_(u,v) + g_v-g_u=0, or None if impossible.

    This directly checks EVERY edge; no cycle-basis/rank/orbit calls.
    """
    adj={v:[] for v in vertices}
    for (u,v),a in zip(edges,labels):
        adj[u].append((v,a))
        adj[v].append((u,-a))
    g={}
    for root in vertices:
        if root in g:continue
        g[root]=0
        stack=[root]
        while stack:
            u=stack.pop()
            for v,signed_a in adj[u]:
                target=(g[u]-signed_a)%p
                if v not in g:
                    g[v]=target
                    stack.append(v)
                elif g[v]!=target:
                    return None
    if set(g)!=set(vertices):raise AssertionError('potential vertex mismatch')
    if any((a+g[v]-g[u])%p for (u,v),a in zip(edges,labels)):
        raise AssertionError('potential equation failed')
    return g


def certificate(n, edges, p, r, include_potentials=False):
    check_prime(p)
    bs=balls(n,edges,r)
    global_cycles=fundamental_cycles(tuple(range(n)),tuple(range(len(edges))),edges,p)
    local_cycles=[z for vs,ids in bs for z in fundamental_cycles(vs,ids,edges,p)]
    W=row_basis(local_cycles,p)
    Z=row_basis(global_cycles,p)
    if not len(W)<=len(Z):raise AssertionError('local cycles exceed global space')
    # Extend the local span to a global cycle basis. This construction is
    # independent of the previous quotient-observation rank calculator.
    full=W[:]
    for z in Z:
        if linear_rank_mod_p(full+[z],p)>len(full):full.append(z)
    if len(full)!=len(Z):raise AssertionError('global basis extension mismatch')
    k=len(full)-len(W)
    hidden=[]; potentials=[]
    for i in range(k):
        rhs=[0]*len(full)
        rhs[len(W)+i]=1
        a=solve_full_row_rank(full,rhs,len(edges),p)
        # Verify nonzero global class by explicit no-potential check.
        if local_potential(range(n),edges,a,p) is not None:
            raise AssertionError('claimed hidden class globally gauge trivial')
        local_gauges=[]
        for vs, ids in bs:
            g=local_potential(vs,[edges[j] for j in ids],[a[j] for j in ids],p)
            if g is None:raise AssertionError('local quotient detects hidden class')
            if include_potentials: local_gauges.append({str(v):g[v] for v in vs})
        hidden.append(a)
        if include_potentials: potentials.append(local_gauges)
    # Direct linear independence test of produced global classes.
    eval_matrix=[[sum(x*y for x,y in zip(z,a))%p for a in hidden] for z in Z]
    if linear_rank_mod_p(eval_matrix,p)!=k:
        raise AssertionError('global hidden classes not independent')
    return {'b1':len(Z),'visible':len(W),'hidden':k,
            'labels':hidden,'potentials':potentials if include_potentials else None}


def audit(seconds=35):
    start=time.monotonic()
    counts={'cycle_radius_cases':0,'all_simple_graph_cases':0,
            'adversarial_cases':0,'nontrivial_hidden_classes':0,'negative_controls':0}
    selected=[]
    def check(n,edges,p,r,name):
        if time.monotonic()-start>seconds:raise TimeoutError('TIME_GUARD: INCOMPLETE')
        c=certificate(n,edges,p,r,include_potentials=(name=='chorded_five' and p==2 and r==1))
        if c['visible']+c['hidden']!=c['b1']:raise AssertionError('rank identity')
        if c['hidden']>0:counts['nontrivial_hidden_classes']+=1
        if name.startswith('cycle_'):
            assert c['b1']==1 and c['hidden']==int(r<n//2)
        if name=='chorded_five' and p==2 and r==1:
            if not (c['b1']==2 and c['visible']==1 and c['hidden']==1):
                raise AssertionError('partial-observation example mismatch')
            selected.append({'name':name,'p':p,'r':r,'edges':[list(e) for e in edges],
                'cochains':c['labels'],'local_vertex_potentials':c['potentials'],
                'global_cycle_dimensions':c['b1'],
                'visible_dimensions':c['visible'],'hidden_dimensions':c['hidden']})
        if r>=n:
            if c['hidden']!=0:raise AssertionError('full observation failed')
            counts['negative_controls']+=1
        return c
    for n in range(3,19):
        nn,e=cycle(n)
        for p in (2,3,5):
            for r in range(n//2+2):
                check(nn,e,p,r,'cycle_'+str(n));counts['cycle_radius_cases']+=1
    for n in range(2,5):
        all_e=list(itertools.combinations(range(n),2))
        for bits in itertools.product((0,1),repeat=len(all_e)):
            nn,e=graph(n,[v for v,b in zip(all_e,bits) if b])
            for p in (2,3):
                for r in range(n+1):
                    check(nn,e,p,r,'simple_graph');counts['all_simple_graph_cases']+=1
    adversarial=[
      ('chorded_five',5,[(0,1),(1,2),(2,3),(3,4),(4,0),(0,2)]),
      ('two_triangles_bridge',6,[(0,1),(1,2),(2,0),(2,3),(3,4),(4,5),(5,3)]),
      ('theta_234',8,[(0,1),(1,7),(0,2),(2,3),(3,7),(0,4),(4,5),(5,6),(6,7)]),
      ('K5',5,list(itertools.combinations(range(5),2))),
    ]
    for name,n,es in adversarial:
        nn,e=graph(n,es)
        for p in (2,3,5):
            for r in range(n+1):
                check(nn,e,p,r,name);counts['adversarial_cases']+=1
    # Independent rejection: visible triangle cycle at radius=1 must be
    # detectable, not misclassified as hidden on the chorded five-cycle.
    nn,e=graph(5,adversarial[0][2]);vs,ids=next((vs,ids) for vs,ids in balls(nn,e,1)
                                    if len(fundamental_cycles(vs,ids,e,2))>0)
    lbl=[0]*len(e)
    triangle_cycle=fundamental_cycles(vs,ids,e,2)[0]
    edge_index=next(i for i,v in enumerate(triangle_cycle) if v%2)
    lbl[edge_index]=1
    if local_potential(vs,[e[j] for j in ids],[lbl[j] for j in ids],2) is not None:
        raise AssertionError('negative control erroneously passed')
    counts['negative_controls']+=1
    # Mutation controls: changing a claimed local potential or an edge label
    # on the observed triangle must invalidate the corresponding certificate.
    fixture=next(item for item in selected if item['name']=='chorded_five')
    a=fixture['cochains'][0]
    all_balls=balls(nn,e,1)
    vs0, ids0=all_balls[0]
    g0={int(v):v0 for v,v0 in fixture['local_vertex_potentials'][0][0].items()}
    if any((a[j]+g0[e[j][1]]-g0[e[j][0]])%2 for j in ids0):
        raise AssertionError('unmutated local gauge certificate invalid')
    # Every vertex change at an endpoint of an observed edge breaks an edge.
    endpoint=e[ids0[0]][0]
    tampered=dict(g0);tampered[endpoint]^=1
    if not any((a[j]+tampered[e[j][1]]-tampered[e[j][0]])%2 for j in ids0):
        raise AssertionError('tampered gauge potential undetected')
    counts['negative_controls']+=1
    tampered_cochain=list(a);tampered_cochain[edge_index]^=1
    if local_potential(vs,[e[j] for j in ids],[tampered_cochain[j] for j in ids],2) is not None:
        raise AssertionError('tampered edge label undetected')
    counts['negative_controls']+=1
    return {'result':'COMPUTATION_PASS','source':'explicit global cochain + per-ball local gauge certificates',
            'counts':counts,'witnesses':selected,
            'assumptions':['finite simple graphs','Fp, prime p','induced radius balls',
                           'independent local gauge choices, no cross-ball synchronization'],
            'proof_status':'FINITE_CERTIFICATE_ONLY','lean_graph_pairing':'OPEN',
            'legacy_toolkit':'NOT_RUN','novelty':'NOT_ESTABLISHED',
            'resource_limits':{'seconds':seconds,'max_graph_vertices':18,'primes':[2,3,5]}}


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--seconds',type=int,default=35)
    ap.add_argument('--out',type=Path)
    args=ap.parse_args()
    data=audit(args.seconds)
    raw=(json.dumps(data,sort_keys=True,indent=2)+'\n').encode()
    if args.out:args.out.write_bytes(raw)
    print(json.dumps({k:v for k,v in data.items() if k!='witnesses'},indent=2,sort_keys=True))
    print('RECEIPT_SHA256 :=',hashlib.sha256(raw).hexdigest())

if __name__=='__main__':main()
