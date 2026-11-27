# Mathematical results (analytic; Lean NOT RUN)

All results refer to stipulated models, not human psychological laws. Normalize states to [0,1] where applicable.

## Scalar dynamics
For b' = b + (1-r)[alpha(e-b)+beta(s-b)], constant targets and nonnegative weights with alpha+beta <= 1, r in [0,1), alpha+beta>0, the unique limit is (alpha e+beta s)/(alpha+beta). Subtraction of this equilibrium gives geometric contraction by 1-(1-r)(alpha+beta). Rigidity affects speed, not the limit. Absolute displacement from e is beta |s-e|/(alpha+beta).

For A=A0(1-pd), B=B0(1-qd), with positive baselines and admissible d,p,q in [0,1], the derivative of A/(A+B) is A0 B0(q-p)/(A+B)^2 where defined. Relative independence can increase while absolute evidence response falls: A,B change from (.5,.5) to (.4,.1).

## Resilience and communities
For d'=(1-rho)d+rho o and A'=(1-lambda)A+lambda A0(1-pd), with positive rates <=1, o<=O, limsup d<=O and liminf A>=A0(1-pO). For v'=(1-eta)v+eta m and c'=(1-gamma)c+gamma h(1-o), bounds m>=M,h>=H give invariant lower bounds v>=M,c>=H(1-O) if initially satisfied. With d<=D, D>=O, A>=Amin>0, Amin<=A0(1-pD), B<=B0 preserved by analogous convex updates, A/(A+B)>=Amin/(Amin+B0). These follow from convex combinations.

With community weights w_i>=0 summing to 1, O=sum w_i o_i, C=sum w_i h_i(1-o_i), critical engagement K=sum w_i h_i(1-o_i)k_i, all factors in [0,1], 0<=K<=C; C=1 does not imply K>0. For two communities with complete exclusion in the first, exposure w, and constructive support H>0 in the second, c'=(1-gamma)c+gamma(1-w)H tends to (1-w)H. A positive limiting threshold cmin is met iff w<=1-cmin/H.

## Coupled bounded dynamics
Let M=[[1-k,a],[c,1-eta]], 0<k,eta<=1. The unbounded linear deviation system is Schur stable iff k*eta-k-eta < a*c < k*eta (Jury criterion). For nonnegative couplings this reduces to a*c<k*eta. For box projection around admissible targets, |a*c|<k*eta suffices for global contraction: choose r>0 with |c|/eta<r and |a|r<k; the weighted max norm max(|x|,|y|/r) has Lipschitz constant L=max(1-k+|a|r,1-eta+|c|/r)<1. Additive bounded disturbances of norm <=eps yield error <=L^t error0+eps(1-L^t)/(1-L).

For centered targets and positive a,c, write S=clamp to [-h,h], h=1/2, F(z)=S(Mz). Fixed points satisfy x=S(ry), y=S(sx), r=a/k,s=c/eta. If rs<1 only zero; if rs=1 a line segment; if rs>1 exactly zero and +/- (h min(1,r),h min(1,s)). Proof: nonzero coordinates share sign, unsaturated nonzero fixed points require rs=1; saturation gives the listed unique positive solution for rs>1. Positive initial states converge to the positive fixed point by monotone sandwich between a small positive multiple of that point (a subsolution) and the upper corner (a supersolution); negative states by oddness.

With W=diag(c,a), WM symmetric. Energy E(x,y)= (||x||_W^2+||y||_W^2)/2 - x^T W M y satisfies E(X_t,X_{t+1})-E(X_{t+1},X_{t+2}) >= ||X_{t+2}-X_t||_W^2/2: F(y) uniquely minimizes ||z||_W^2/2-z^T W M y over the box. Compactness implies two-step differences vanish and periods above two are excluded. Nontrivial period two exists iff a*c >= (2-k)(2-eta). Necessity: firm nonexpansiveness of projection implies ||u-v||_W^2 <= -(u-v)^T WM(u-v). Sufficiency: at equality scale a -1 eigenvector; above equality minimize z^T W(I+M)z/2 over the box, obtaining nonzero z with z=S(-Mz)=-F(z) by first-order optimality. In k*eta<a*c<(2-k)(2-eta), accumulation points are fixed and finite, successive differences vanish, hence every trajectory converges. Central basin equals union of all iterated preimages of the stable eigenspace intersected with the box: eventual convergence to zero forces eventual unsaturated linear evolution with no unstable component, and the stable eigenspace contracts without clipping.

Symmetric k=eta,a=c, intermediate k<a<2-k: sign of x+y is preserved, since raw sum=(1-k+a)(x+y), raw difference has magnitude <1 and opposite simultaneous saturation is impossible. Nonzero sum cannot tend to zero by eventual linear expansion, so positive/negative sums converge to corresponding corners, zero sum to zero.

Strict symmetric oscillatory case a>2-k: let d=1-k, P swap coordinates, G=PF. P and G commute and F^t=P^t G^t. G has symmetric positive definite matrix [[a,d],[d,a]], so period two is excluded by firm nonexpansiveness. Solving its fixed point equations yields nine points: zero, four corners, and (h,-q),(-q,h),(-h,q),(q,-h), q=d*h/(a-1). Finite fixed set and energy argument imply G convergence; even/odd F subsequences converge to z,Pz. This does not classify general asymmetric basins or critical cases.

## Coping and controllability
For A_t in [0,1], 0<alpha<1, C0>0, C_{t+1}=(1-alpha A_t)C_t, C_t=C0 product(1-alpha A_j). C_t tends to zero iff sum A_j diverges, by alpha A_j <= -log(1-alpha A_j) <= alpha A_j/(1-alpha). Let U>=0, U+C0<=1, D'=(1-rho)D+rho(U+C)(1-beta v), rho in (0,1], beta,v in [0,1]. Constant v and divergent cumulative effective action imply D tends to U(1-beta v) by stable scalar filtering. If A=0, distress can fall while burden is unchanged. This idealization excludes new burdens and uncertain action efficacy; compensation is not necessarily avoidance.
