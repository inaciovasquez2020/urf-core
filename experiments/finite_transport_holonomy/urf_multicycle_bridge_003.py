#!/usr/bin/env python3
"""Exact multi-cycle holonomy code tests, standard-library only."""
from fractions import Fraction as F
from itertools import product

N=12
# Theta graph: three paths between two common vertices.
# Oriented loop rows are path1-path2, path2-path3, path1-path3.
C=((1,-1,0),(0,1,-1),(1,0,-1))

def moddist(x,y):
    z=(x-y)%N
    return min(z,N-z)

def syndrome(a):
    return tuple(sum(row[j]*a[j] for j in range(3))%N for row in C)

classes=sorted(set(syndrome(a) for a in product(range(N),repeat=3)))
assert len(classes)==N*N
# possible classes are (u,v,u+v) and three loop readings are redundant
assert all((s[0]+s[1])%N==s[2] for s in classes)

def d_inf(x,y): return max(moddist(a,b) for a,b in zip(x,y))
def d_l1(x,y): return sum(moddist(a,b) for a,b in zip(x,y))
min_inf=min(d_inf(x,y) for i,x in enumerate(classes) for y in classes[i+1:])
min_l1=min(d_l1(x,y) for i,x in enumerate(classes) for y in classes[i+1:])
assert (min_inf,min_l1)==(1,2)

# Error-correcting code { (u,v,u+v) }. One faulty measurement is not always correctable.
# For example adjacent legitimate codewords differ in two positions, so one
# adversarial corrupted coordinate can make a received word ambiguous.
a=(0,0,0); b=(1,0,1)
r=(1,0,0)
assert d_l1(a,r)==1 and d_l1(b,r)==1

# If each original path transport has bounded real error epsilon,
# the maximum noise in any two-path cycle is 2 epsilon; the
# min separation in L_infinity is 1: sufficient epsilon < 1/4.
# This is sharp: take underlying path transport a=(0,0,0)
# and b=(1/2,-1/2,-1/2). But b has integer loop values (1,0,1)
# and mid-point path observation lies within 1/4 of both.
pa=(F(0),F(0),F(0)); pb=(F(1,2),-F(1,2),-F(1,2))
obs=tuple((x+y)/2 for x,y in zip(pa,pb))
assert max(abs(obs[i]-pa[i]) for i in range(3))==F(1,4)
assert max(abs(obs[i]-pb[i]) for i in range(3))==F(1,4)
assert syndrome(pa)==(0,0,0) and syndrome(pb)==(1,0,1)
# Verify the actual observed loop signature is equally close to the two
# admissible codewords, not merely that the path observations overlap.
obs_signature = tuple(sum(C[i][j]*obs[j] for j in range(3)) % N
                      for i in range(3))
assert d_inf(obs_signature, syndrome(pa)) == F(1,2)
assert d_inf(obs_signature, syndrome(pb)) == F(1,2)
assert not any(d_inf(obs_signature, s) < F(1,2) for s in classes)

# Exact finite error sweep: for each codeword test all e in {-1/5,0,1/5}^3
# on the measured loop signatures; nearest L-infinity codeword is unique.
noise=(-F(1,5),F(0),F(1,5))
checks=0
for s in classes:
    for e in product(noise,repeat=3):
        r=tuple(F(s[i])+e[i] for i in range(3))
        ds=[max(min(abs(r[i]-t[i]+N*k) for k in (-1,0,1)) for i in range(3)) for t in classes]
        assert ds.count(min(ds))==1 and classes[ds.index(min(ds))]==s
        checks+=1
print('MODEL := theta graph; three oriented paths; modulus 12')
print('ADMISSIBLE_CLASSES :=',len(classes))
print('MIN_CIRCULAR_LINFINITY_DISTANCE :=',min_inf)
print('MIN_CIRCULAR_L1_DISTANCE :=',min_l1)
print('EXHAUSTIVE_NOISE_GRID_CHECKS :=',checks)
print('ONE_CORRUPTED_COORDINATE_ALWAYS_CORRECTABLE := FALSE')
print('PATH_ERROR_SUFFICIENT_BOUND := epsilon < 1/4')
print('PATH_ERROR_BOUND_SHARP := PASS')
print('STATUS := COMPUTATION_PASS')
