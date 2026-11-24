import itertools as I,time,sys
start=time.monotonic()
def rank(xs):
 b={}
 for x in xs:
  while x:
   p=x.bit_length()-1
   if p in b:x^=b[p]
   else:b[p]=x;break
 return len(b)
def guard():
 if time.monotonic()-start>25:raise RuntimeError('INCOMPLETE: time guard')
def gadget(n,sets,t):
 b=0;s=list(range(1,1+len(sets))); L=[];E=set(I.combinations(s,2));v=1+len(s)
 def add(a,b): E.add(tuple(sorted((a,b))))
 for l in range(2*t+1):
  a=v;x=list(range(v+1,v+n+2));v+=n+2;L.append([a]+x)
  for y in x:add(a,y);add(b,y)
  for j,z in enumerate(s):
   add(a,z);add(z,x[0])
   for i in range(n):
    if sets[j]>>i&1:add(z,x[i+1])
 return v,E,s,L
def h1(v,E):
 ix={e:i for i,e in enumerate(sorted(E))}; adj=[set() for _ in range(v)]
 for a,b in E:adj[a].add(b);adj[b].add(a)
 tris=[]
 for a,b in E:
  for c in adj[a]&adj[b]:
   if c>b:tris.append((1<<ix[a,b])^(1<<ix[a,c])^(1<<ix[b,c]))
 # gadget connected; insertion preserves connectivity
 return len(E)-v+1-rank(tris)
instances=checks=successes=0
for n in (1,2):
 for m in (1,2):
  for sets in I.combinations_with_replacement(range(1<<n),m):
   for t in range(1,m+1):
    guard();v,E,s,L=gadget(n,sets,t); missing=sorted(set(I.combinations(range(v),2))-E)
    solved=False;expected=any(__import__('functools').reduce(int.__or__,(sets[j] for j in J),0)==(1<<n)-1 for k in range(t+1) for J in I.combinations(range(m),k))
    for k in range(t+1):
     for A in I.combinations(missing,k):
      checks+=1
      if checks%1024==0:guard()
      if h1(v,E|set(A))==0:
       successes+=1;solved=True
       mask=0
       for j,z in enumerate(s):
        if (0,z) in A:mask|=sets[j]
       assert mask==(1<<n)-1,(n,sets,t,A)
    assert solved==expected,(n,sets,t)
    instances+=1
print('PYTHON',sys.version.split()[0])
print('INSTANCES',instances,'ADDITIONS',checks,'SUCCESSFUL',successes,'PASS')
