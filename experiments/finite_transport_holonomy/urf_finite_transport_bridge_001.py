#!/usr/bin/env python3
"""Exact finite connection checks; Python 3 standard library only.
NOT a Lean proof or a physical fifth-dimensional model.
"""
from itertools import product
from collections import Counter

# Python optimization strips assertions; never certify a stripped execution.
if not __debug__:
    raise SystemExit("OPTIMIZED_EXECUTION_REJECTED: assertions are disabled")

N = 12

def hol(edges):
    """Return the oriented cycle holonomy modulo 12."""
    return sum(edges) % N

def triangle_gauge(edges, vertices):
    """Apply the coboundary of vertex potentials to three edge values."""
    """Edges 0->1,1->2,2->0; a_uv -> a_uv + g_v - g_u."""
    a,b,c = edges
    x,y,z = vertices
    return ((a+y-x)%N, (b+z-y)%N, (c+x-z)%N)

all_edges = list(product(range(N),repeat=3))
classes = Counter(map(hol, all_edges))
assert len(all_edges) == 1728
assert len(classes) == 12 and set(classes.values()) == {144}
for e in all_edges:
    for g in product(range(N),repeat=3):
        # All 1728 * 1728 gauge checks; still bounded and exact.
        assert hol(e) == hol(triangle_gauge(e,g))
print('TRIANGLE_TRANSPORT_GAUGE_INVARIANCE := PASS',len(all_edges)*N**3)
print('UNFILLED_CYCLE_GAUGE_CLASSES :=',len(classes),'CONFIGURATIONS_PER_HOLONOMY :=',set(classes.values()))
flat=[e for e in all_edges if hol(e)==0]
assert len(flat)==144
print('FILLED_TRIANGLE_FLAT_CONFIGURATIONS :=',len(flat),'FLAT_HOLONOMY_CLASSES :=',len(set(map(hol,flat))))
# Mod-2 reduction of Z/12 transport retains parity but destroys information.
parity_classes = Counter(h%2 for h in map(hol,all_edges))
assert parity_classes == {0:864, 1:864}
assert 1%2==3%2 and 1!=3
print('MOD2_COLLISION := PASS; examples holonomy 1 vs 3 in Z/12')
# Annulus: 6 triangles with cyclic indices; edge values derived from a real closed 1-cochain.
faces=[(0,1,4),(0,4,3),(1,2,5),(1,5,4),(2,0,3),(2,3,5)]
arcs={(0,1):0,(1,2):0,(2,0):1,(3,4):0,(4,5):0,(5,3):1,
      (0,3):0,(1,4):0,(2,5):0,(0,4):0,(1,5):0,(2,3):1}
def edge(u,v):
    """Read a directed annulus edge with reversal sign."""
    if (u,v) in arcs: return arcs[(u,v)]
    if (v,u) in arcs: return -arcs[(v,u)]
    raise ValueError((u,v))
def face_curvature(f):
    """Sum directed edge values around one triangular face."""
    u,v,w=f
    return (edge(u,v)+edge(v,w)+edge(w,u))%N
assert all(face_curvature(f)==0 for f in faces)
assert (edge(0,1)+edge(1,2)+edge(2,0))%N==1
assert (edge(3,4)+edge(4,5)+edge(5,3))%N==1
print('ANNULUS_FACES_FLAT := PASS',len(faces),'NONZERO_INNER_OUTER_HOLONOMY := 1,1')
print('RESULT := COMPUTATION_PASS (finite exact arithmetic only)')
