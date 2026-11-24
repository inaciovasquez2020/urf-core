#!/usr/bin/env python3
"""Independent bounded GF(p) check: radius-local cycle spans and sharp query count.

No dependencies. Exhaustive labeled connected simple graphs n<=5 for p=2;
n<=4 for p=3; selected adversarial graphs with p=2,3,5.
Uses two independently enumerated spanning descriptions of R_r:
  (1) cycles supported in a closed radius-r ball;
  (2) simple cycles of length <=2*r+1.
The theorem holds for all finite simple graphs by paper proof, not by this test.
"""
from collections import Counter, deque
from itertools import combinations, product
from time import monotonic
import platform
import sys

TIME_LIMIT=65.0
STATE_LIMIT=100000
started=monotonic()
cnt=Counter()

def budget():
    if monotonic()-started>TIME_LIMIT:
        raise TimeoutError('INCOMPLETE: time guard hit')

def rank(rows,p,n):
    a=[[x%p for x in row] for row in rows]
    k=0
    for j in range(n):
        hit=next((i for i in range(k,len(a)) if a[i][j]),None)
        if hit is None: continue
        a[k],a[hit]=a[hit],a[k]
        z=pow(a[k][j],-1,p)
        a[k]=[(t*z)%p for t in a[k]]
        for i in range(len(a)):
            if i!=k and a[i][j]:
                z=a[i][j]
                a[i]=[(t-z*s)%p for t,s in zip(a[i],a[k])]
        k+=1
        if k==len(a): break
    return k

def adjacencies(n,edges):
    adj=[set() for _ in range(n)]
    for u,v in edges:
        adj[u].add(v);adj[v].add(u)
    return adj

def balls(adj,r):
    n=len(adj)
    result=[]
    for root in range(n):
        seen={root};frontier={root}
        for _ in range(r):
            frontier=set.union(set(),*(adj[u] for u in frontier))-seen
            seen|=frontier
        result.append(seen)
    return result

def spanning_tree(adj):
    seen={0};q=deque([0]);tree=set()
    while q:
        u=q.popleft()
        for v in sorted(adj[u]):
            if v not in seen:
                seen.add(v);tree.add((min(u,v),max(u,v)));q.append(v)
    if len(seen)!=len(adj):return None
    return tree

def all_simple_cycles(adj):
    n=len(adj);out=[]
    # Every undirected cycle recorded once: smallest start, smaller first neighbor.
    for s in range(n):
        def dfs(path,seen):
            u=path[-1]
            for v in sorted(adj[u]):
                if v==s:
                    if len(path)>=3 and path[1]<path[-1]:out.append(tuple(path))
                elif v>s and v not in seen:
                    dfs(path+[v],seen|{v})
        dfs([s],{s})
    return out

def cycle_chain(cycle,edges):
    idx={e:i for i,e in enumerate(edges)}
    row=[0]*len(edges)
    for u,v in zip(cycle,cycle[1:]+cycle[:1]):
        row[idx[(min(u,v),max(u,v))]]+=(1 if u<v else -1)
    return row

def brute_fibers(rows,p,b):
    if p**b>STATE_LIMIT:raise TimeoutError('INCOMPLETE: state guard hit')
    counts=Counter()
    for x in product(range(p),repeat=b):
        obs=tuple(sum(a*v for a,v in zip(row,x))%p for row in rows)
        counts[obs]+=1
    return counts

def verify(n,edges,p):
    budget()
    adj=adjacencies(n,edges)
    tree=spanning_tree(adj)
    if tree is None:return
    chords=[e for e in edges if e not in tree]
    idx={e:i for i,e in enumerate(edges)}
    b=len(chords)
    cycles=all_simple_cycles(adj)
    chains=[cycle_chain(c,edges) for c in cycles]
    # Independent vector-space basis crosscheck: all simple cycles span Z.
    inc=[[0]*len(edges) for _ in range(n)]
    for j,(u,v) in enumerate(edges):
        inc[u][j]=-1;inc[v][j]=1
    assert rank(inc,p,len(edges))==n-1
    for z in chains:
        assert all(sum(x*y for x,y in zip(v,z))%p==0 for v in inc)
    assert rank(chains,p,len(edges))==b
    for r in range(n):
        localballs=balls(adj,r)
        local=[z for c,z in zip(cycles,chains)
               if any(set(c)<=ball for ball in localballs)]
        short=[z for c,z in zip(cycles,chains) if len(c)<=2*r+1]
        # Two *different* generators for the same local cycle space.
        rl=rank(local,p,len(edges));rs=rank(short,p,len(edges))
        assert rl==rs==rank(local+short,p,len(edges)),('radius_support_fail',n,edges,p,r)
        rows=[[z[idx[e]]%p for e in chords] for z in local]
        assert rank(rows,p,b)==rl
        h=b-rl
        fibers=brute_fibers(rows,p,b)
        assert len(fibers)==p**rl
        assert set(fibers.values())=={p**h}
        # Add a complement basis of q-ary cycle probes, test every depth.
        selected=[];span=list(rows)
        for j in range(b):
            e=[int(k==j) for k in range(b)]
            if rank(span+[e],p,b)>rank(span,p,b):
                selected.append(e);span.append(e)
        assert len(selected)==h and rank(span,p,b)==b
        for m in range(h+1):
            obs=rows+selected[:m]
            f=brute_fibers(obs,p,b)
            assert len(f)==p**(rl+m)
            assert set(f.values())=={p**(h-m)}
            cnt['probe_depth_certificates']+=1
            cnt['probe_state_checks']+=p**b
        cnt['radius_certificates']+=1
        cnt['state_checks']+=p**b
        cnt[f'hidden_{h}']+=1
    cnt[f'prime_{p}_graphs']+=1
    cnt['graphs']+=1
    cnt['simple_cycles_examined']+=len(cycles)

def edges_for(n,pairs):
    return tuple(sorted((min(u,v),max(u,v)) for u,v in pairs))


def full_edge_gauge_audit(n,edges,p,r):
    """Independent raw-edge/gauge orbit enumeration, not using a cycle-basis decoder."""
    budget()
    adj=adjacencies(n,edges)
    tree=spanning_tree(adj)
    assert tree is not None
    b=len(edges)-n+1
    if p**len(edges)>40000:raise TimeoutError('INCOMPLETE: gauge-state cap hit')
    idx={e:i for i,e in enumerate(edges)}
    chords=[e for e in edges if e not in tree]
    bs=balls(adj,r)
    cyc=[c for c in all_simple_cycles(adj) if any(set(c)<=s for s in bs)]
    chains=[cycle_chain(c,edges) for c in cyc]
    local_chord_rows=[[z[idx[e]]%p for e in chords] for z in chains]
    orbit_count=Counter()
    for a in product(range(p),repeat=len(edges)):
        potential=[None]*n;potential[0]=0;q=deque([0])
        while q:
            u=q.popleft()
            for v in sorted(adj[u]):
                edge=(min(u,v),max(u,v))
                if edge not in tree or potential[v] is not None:continue
                sign=1 if u<v else -1
                potential[v]=(potential[u]-sign*a[idx[edge]])%p
                q.append(v)
        assert all(t is not None for t in potential)
        gauge=[(a[j]+potential[v]-potential[u])%p for j,(u,v) in enumerate(edges)]
        assert all(gauge[idx[e]]==0 for e in tree)
        x=tuple(gauge[idx[e]] for e in chords)
        orbit_count[x]+=1
        local_orig=tuple(sum(k*z for k,z in zip(a,row))%p for row in chains)
        local_gauge=tuple(sum(k*z for k,z in zip(gauge,row))%p for row in chains)
        local_repr=tuple(sum(k*z for k,z in zip(x,row))%p for row in local_chord_rows)
        assert local_orig==local_gauge==local_repr
        cnt['raw_edge_gauge_states']+=1
    assert len(orbit_count)==p**b
    assert set(orbit_count.values())=={p**(n-1)}
    cnt['raw_gauge_cases']+=1
    print('GAUGE_ORBIT_AUDIT := PASS N :=',n,'Q :=',p,'R :=',r,
          'ORBIT_COUNT :=',len(orbit_count),'RAW_ASSIGNMENTS :=',sum(orbit_count.values()))

def run():
    assert __debug__,'INCOMPLETE: assertions disabled'
    print('PYTHON :=',platform.python_version(),'TIME_LIMIT :=',TIME_LIMIT,'STATE_LIMIT :=',STATE_LIMIT)
    for n in range(2,6):
        poss=list(combinations(range(n),2))
        for mask in range(1<<len(poss)):
            ed=tuple(e for j,e in enumerate(poss) if mask&(1<<j))
            if spanning_tree(adjacencies(n,ed)) is None:continue
            verify(n,ed,2)
            if n<=4:verify(n,ed,3)
        print('GF2_LABELLED_CONNECTED_UP_TO_N :=',n,'COUNT :=',cnt['prime_2_graphs'])
    examples={
       'C6':(6,edges_for(6,[(i,(i+1)%6) for i in range(6)])),
       'C7':(7,edges_for(7,[(i,(i+1)%7) for i in range(7)])),
       'TRIANGULAR_PRISM':(6,edges_for(6,[(0,1),(1,2),(2,0),(3,4),(4,5),(5,3),(0,3),(1,4),(2,5)])),
       'TWO_SQUARES_WEDGE':(7,edges_for(7,[(0,1),(1,2),(2,3),(3,0),(0,4),(4,5),(5,6),(6,0)])),
       'K5':(5,tuple(combinations(range(5),2))),
    }
    for name,(n,ed) in examples.items():
        for p in (2,3,5):verify(n,ed,p)
        print('FAMILY :=',name,'EXACT_RADII :=',n)
    for name,q,r in [('C6',3,1),('TRIANGULAR_PRISM',2,1),
                     ('TRIANGULAR_PRISM',3,1),('TWO_SQUARES_WEDGE',3,1),
                     ('K5',2,1)]:
        n,ed=examples[name]
        full_edge_gauge_audit(n,ed,q,r)
    for k in sorted(cnt):print(k.upper(),':=',cnt[k])
    print('STATUS := COMPUTATION_PASS (bounded; analytic theorem separate)')
    print('LEAN := NOT_RUN')
    print('GIT_MODIFICATIONS := NONE')

if __name__=='__main__':
    try:run()
    except TimeoutError as e:
        print(str(e),file=sys.stderr)
        sys.exit(2)
