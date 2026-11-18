#!/usr/bin/env python3
"""Exact torsion-sensitive clique H1 witness, standard library only.

Take a 6-vertex combinatorial triangulation of RP2 (10 facets).
The inclusion-comparability graph of all nonempty faces has 31 vertices.
Its clique complex is the barycentric subdivision of RP2.
Field-dependent first Betti numbers:
    beta1(F2)=1, beta1(F3)=beta1(F5)=0.

No external packages, no downloads, no writes.
"""
from itertools import combinations
from collections import Counter

FACETS = (
    (0,1,2), (0,1,3), (0,2,4), (0,3,5), (0,4,5),
    (1,2,5), (1,3,4), (1,4,5), (2,3,4), (2,3,5),
)

def rank(rows, prime, cols):
    a = [[x % prime for x in row] for row in rows]
    r = 0
    for c in range(cols):
        i = next((k for k in range(r, len(a)) if a[k][c]), None)
        if i is None:
            continue
        a[r],a[i] = a[i],a[r]
        inv = pow(a[r][c], -1, prime)
        a[r] = [(v * inv) % prime for v in a[r]]
        for k in range(r + 1, len(a)):
            mul = a[k][c]
            if mul:
                a[k] = [(x-mul*y) % prime for x,y in zip(a[k],a[r])]
        r += 1
        if r == len(a):
            break
    return r

def main():
    face_set = set()
    for t in FACETS:
        for size in (1,2,3):
            face_set.update(frozenset(c) for c in combinations(t, size))
    faces = sorted(face_set, key=lambda f:(len(f),tuple(sorted(f))))
    assert Counter(map(len,faces)) == {1:6,2:15,3:10}
    for v in range(6):
        link_edges = [
            frozenset(set(t)-{v}) for t in FACETS if v in t
        ]
        deg = Counter(x for e in link_edges for x in e)
        assert len(link_edges) == 5 and sorted(deg.values()) == [2]*5
        # A five-vertex 2-regular simple graph is a 5-cycle.
    edge_incidence = Counter(e for t in FACETS
                             for e in combinations(t,2))
    assert len(edge_incidence)==15 and set(edge_incidence.values())=={2}

    n = len(faces)
    graph_edges = [
        (i,j) for i in range(n) for j in range(i+1,n)
        if faces[i] < faces[j]
    ]
    triangles = [
        (i,j,k) for i in range(n) for j in range(i+1,n)
        for k in range(j+1,n)
        if faces[i] < faces[j] < faces[k]
    ]
    assert (n,len(graph_edges),len(triangles)) == (31,90,60)
    # Comparability cliques are chains: all triangular cliques are listed.
    assert all(
        ((i,j) in graph_edges and (j,k) in graph_edges
         and (i,k) in graph_edges)
        for i,j,k in triangles)
    d1 = [
        [(-1 if v==a else 1 if v==b else 0)
         for a,b in graph_edges]
        for v in range(n)
    ]
    d2 = [
        [(1 if (a,b)==(i,j) else -1 if (a,b)==(i,k)
          else 1 if (a,b)==(j,k) else 0)
         for i,j,k in triangles]
        for a,b in graph_edges
    ]
    for prime, expected in ((2,(30,59,1)),(3,(30,60,0)),(5,(30,60,0))):
        for v in range(n):
            for t in range(len(triangles)):
                assert sum(d1[v][e]*d2[e][t]
                           for e in range(len(graph_edges))) % prime == 0
        r1 = rank(d1,prime,len(graph_edges))
        r2 = rank(d2,prime,len(triangles))
        beta = len(graph_edges)-r1-r2
        assert (r1,r2,beta) == expected, (prime,r1,r2,beta)
        print("FIELD_F%s := RANK_D1:%d RANK_D2:%d BETA1:%d"
              % (prime,r1,r2,beta))
    print("VERTICES := 31")
    print("EDGES := 90")
    print("TRIANGLES := 60")
    print("CHARACTERISTIC_DEPENDENCE := COMPUTATION_PASS")
    print("LEAN_VERIFICATION := NOT_RUN")

if __name__ == "__main__":
    main()
