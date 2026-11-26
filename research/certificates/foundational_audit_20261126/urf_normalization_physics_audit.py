#!/usr/bin/env python3
"""Bounded independent replay of local machine rules and analytical corrections."""
from itertools import product
from fractions import Fraction as Q
from collections import Counter
import signal,sys
signal.signal(signal.SIGALRM,lambda *_:sys.exit('RESULT := INCOMPLETE_TIMEOUT'))
signal.alarm(90)
# Each entry specifies write symbol, new control state, and signed head displacement.
options=list(product(range(2),range(2),(-1,1)))
# State encoding: (symbol, head/control or -1); fixed blank padding outside array.
blank=(0,-1)
def reference(row,table):
    out=list(row);h=next(i for i,(_,q) in enumerate(row) if q!=-1)
    a,q=row[h];b,p,d=table[2*q+a];out[h]=(b,-1);out[h+d]=(row[h+d][0],p)
    return tuple(out)
def rule(l,c,r,table):
    a,q=c
    if q!=-1:return (table[2*q+a][0],-1)
    incoming=[]
    for (b,p),d in ((l,1),(r,-1)):
        if p!=-1:
            _,q2,move=table[2*p+b]
            if move==d:incoming.append(q2)
    assert len(incoming)<=1
    return (a,incoming[0] if incoming else -1)
checks=0
for table in product(options,repeat=4):
    for bits in product(range(2),repeat=3):
        init=tuple((bits[i-4] if 4<=i<=6 else 0,0 if i==5 else -1) for i in range(11))
        ref=local=init
        for t in range(3):
            ref=reference(ref,table)
            local=tuple(rule(local[i-1] if i else blank,local[i],local[i+1] if i+1<len(local) else blank,table) for i in range(len(local)))
            assert ref==local,(table,bits,t)
            checks+=1
print('TM_TABLES := 4096; INPUTS_PER_TABLE := 8; ROUNDS := 3',flush=True)
print('TM_LOCAL_REFERENCE_STEP_COMPARISONS :=',checks,'PASS',flush=True)
# Test accumulating facts on expanded DAG, and exact decoding from incoming-labelled WL colors.
from functools import lru_cache
wlchecks=0
for j,table in enumerate(product(options,repeat=4)):
    if j%64:continue
    for bits in product(range(2),repeat=3):
        n=11;T=3
        init=tuple((bits[i-4] if 4<=i<=6 else 0,0 if i==5 else -1) for i in range(n))
        rows=[init]
        for _ in range(T):rows.append(reference(rows[-1],table))
        nodes=list(product(range(T+1),range(n)))
        # Color representation keeps old color and labelled incoming predecessor colors.
        colors={v:('initial',init[v[1]] if v[0]==0 else None) for v in nodes}
        const=('initial',blank)
        @lru_cache(None)
        def decode(c):
            if c[0]=='initial':return c[1]
            old=decode(c[1])
            if old is not None:return old
            if not c[2]:return None
            pred=tuple(decode(p) for p in c[2])
            return rule(*pred,table) if all(p is not None for p in pred) else None
        for t in range(T+1):
            for s,i in nodes:
                assert decode(colors[s,i])==(rows[s][i] if s<=t else None)
                wlchecks+=1
            colors={(s,i):('next',colors[s,i],tuple(colors.get((s-1,k),const) for k in (i-1,i,i+1)) if s else ()) for s,i in nodes}
print('EXPANDED_DAG_INCOMING_WL_DECODER_NODE_ROUND_CHECKS :=',wlchecks,'PASS',flush=True)
# Exact numerical counterexamples and identities from earlier errata.
assert Q(10000,101)>Q(100,101)+Q(10000,10201) # radial Hessian omitted term
for j in range(1,101):assert Q(1,2*j)>0 and Q(1,2*j)<=Q(1,2) # Rayleigh quotients on L2(0,1)
ob,oc,orr,v=Q('0.05'),Q('0.25'),Q('0.00009'),Q('0.69991')
# Published default fractions yield 160018/300000 with matter total .30009.
assert (3*(ob+oc+orr)+v)/3==Q(160018,300000)
assert 3*(1-ob-oc-orr)==Q('2.09973')
print('RATIONAL_HESSIAN_COERCIVITY_COSMOLOGY := PASS',flush=True)
# Symbolic tensor derivation independently from the metric, not from field equation formulas.
import sympy as s
r,theta,t,phi=s.symbols('r theta t phi',positive=True)
N=s.Function('N')(r);coords=(t,r,theta,phi)
g=s.diag(-N**2,1,r**2,r**2*s.sin(theta)**2);gi=g.inv();dim=4
G=[[[s.simplify(sum(gi[a,k]*(s.diff(g[k,c],coords[b])+s.diff(g[k,b],coords[c])-s.diff(g[b,c],coords[k])) for k in range(dim))/2) for c in range(dim)] for b in range(dim)] for a in range(dim)]
Ric=s.Matrix(dim,dim,lambda b,c:s.simplify(sum(s.diff(G[a][b][c],coords[a])-s.diff(G[a][b][a],coords[c])+sum(G[a][a][k]*G[k][b][c]-G[a][c][k]*G[k][b][a] for k in range(dim)) for a in range(dim))))
scalar=s.simplify(s.trace(gi*Ric));Ein=(Ric-g*scalar/2).applyfunc(s.simplify)
assert s.simplify(Ein[0,0]/N**2)==0
assert s.simplify(Ein[1,1]-2*s.diff(N,r)/(r*N))==0
# shell: conservation fixes Phi'=1/r; solve Einstein radial equation for m.
m=s.symbols('m');sol=s.solve(s.Eq(1/r,m/(r*(r-2*m))),m)
assert sol==[r/3]
assert s.simplify(s.diff(sol[0],r)-4*s.pi*r**2)==s.Rational(1,3)-4*s.pi*r**2
# Gaussian profile full spatial derivatives.
x,y,z,R,e=s.symbols('x y z R e',real=True,nonzero=True);X=s.Matrix([x,y,z]);u=X.dot(X)/R**2
index=1-e*s.exp(-u);grad=s.Matrix([s.diff(index,c) for c in X]);hes=s.hessian(index,tuple(X))
assert all(s.simplify(a)==0 for a in grad-2*e*s.exp(-u)*X/R**2)
assert all(s.simplify(a)==0 for a in hes-2*e*s.exp(-u)*(s.eye(3)-2*X*X.T/R**2)/R**2)
print('SYMPY_VERSION :=',s.__version__)
print('EINSTEIN_TENSOR_SHELL_GAUSSIAN_SYMBOLIC := PASS',flush=True)
signal.alarm(0)
print('RESULT := COMPUTATION_PASS')
