# Identification and obstructions

The existing F10 fiber criterion in ../OBSERVATIONAL_IDENTIFIABILITY.md applies directly: a target is recoverable only if constant on observation fibers.

For scalar belief updates, only A=(1-r)alpha and B=(1-r)beta are visible. For A,B>0 and A+B<1, any r in [0,1-A-B] with alpha=A/(1-r),beta=B/(1-r) produces identical trajectories. Likewise (1-r)qA confounds emotional resistance, perceived evidence quality and baseline responsiveness. Distress modeled as alpha P+beta PH+gamma PV depends on perceived falsehood P, perceived harm H and personal meaning V, not necessarily objective accuracy. Distress alone cannot identify epistemic accuracy in this model.

Effective A,B are uniquely identified by two exact update observations if the design rows (e_i-b_i,s_i-b_i) have nonzero determinant. Singular designs generally fail identification, with possible constrained boundary exceptions.

For simultaneous changes db=a dv+pE+error_b, dv=c db+qR+error_v, independent randomized instruments E,R, mean-independent errors, nonzero p,q, ac!=1 and no direct cross-effects, the reduced-form matrix J=(1-ac)^(-1)[[p,aq],[cp,q]]. Then a=J_bR/J_vR and c=J_vE/J_bE. With unrestricted direct effects, for any invertible structural matrix H=[[1,-a],[-c,1]], choosing direct-effect matrix HJ yields the same reduced form J. Thus randomization alone does not establish the exclusion restrictions. These static coefficients are not automatically the dynamic coefficients of the stability model.

For binary verifiable outcomes with true conditional probability theta, expected Brier loss equals (b-theta)^2+theta(1-theta); calibration is distinct from conviction and reverence.
