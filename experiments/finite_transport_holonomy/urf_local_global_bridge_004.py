#!/usr/bin/env python3
"""Exact local-gauge indistinguishability witness on cycle graphs; stdlib only."""

# Python optimization strips assertions; never certify a stripped execution.
if not __debug__:
    raise SystemExit("OPTIMIZED_EXECUTION_REJECTED: assertions are disabled")

def ball(n,root,r):
    return {v for v in range(n) if min((v-root)%n,(root-v)%n)<=r}

def edges(n,verts):
    return [(i,(i+1)%n) for i in range(n) if i in verts and (i+1)%n in verts]

def local_gauge(n,q,conn,verts):
    # Test whether edge field conn restricted to an induced graph is a vertex coboundary.
    adj={v:[] for v in verts}
    for i,j in edges(n,verts):
        adj[i].append((j,conn[i]%q))
        adj[j].append((i,-conn[i]%q))
    g={}
    for v in verts:
        if v not in g:
            g[v]=0; stack=[v]
            while stack:
                u=stack.pop()
                for w,d in adj[u]:
                    x=(g[u]+d)%q
                    if w in g:
                        if g[w]!=x:return False
                    else:g[w]=x;stack.append(w)
    return True

def test():
    checks=0; local=0; full=0
    for q in (2,3,5,12):
        for n in range(3,21):
            zero=(0,)*n
            for defect in range(n):
                conn=[0]*n;conn[defect]=1
                assert sum(conn)%q != sum(zero)%q
                assert not local_gauge(n,q,conn,set(range(n)))
                full+=1
                for r in range((n-2)//2+1):
                    for root in range(n):
                        b=ball(n,root,r)
                        assert len(b)<n and local_gauge(n,q,conn,b)
                        checks+=1;local+=1
    # A complete-ball counter-control: for odd n, radius floor(n/2) sees all edges.
    controls=0
    for n in (5,7,9,11):
        a=[1]+[0]*(n-1)
        for root in range(n):
            assert ball(n,root,n//2)==set(range(n))
            assert not local_gauge(n,12,a,ball(n,root,n//2))
            controls+=1
    print(f'LOCAL_GAUGE_EQUIVALENCE := PASS; CASES := {checks}')
    print(f'GLOBAL_HOLONOMY_DIFFERENCE := PASS; CASES := {full}')
    print(f'FULL_BALL_NEGATIVE_CONTROLS := PASS; CASES := {controls}')
    print('COMPUTATION_STATUS := COMPUTATION_PASS; LEAN := NOT_RUN')
if __name__=='__main__': test()
