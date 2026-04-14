# Ordered Invariant Compression Hypothesis

Status: OPEN.

\[
\boxed{\textbf{Ordered Invariant Compression Hypothesis (OICH)}}
\]

\[
\forall d\in\mathbb N\ \forall M\in\mathbb N\ \forall \mathcal F\subseteq \mathcal P([M]),
\]

\[
\mathrm{VCdim}(\mathcal F)\le d
\Longrightarrow
\exists \delta_{\mathcal F}:[M]^{\le d}\to \mathcal P([M])
\]

such that

\[
\forall F\in\mathcal F\ \exists S\subseteq F,\ |S|\le d,\ \delta_{\mathcal F}(S)=F,
\]

and

\[
\forall \pi\in\mathrm{Sym}([M]),\qquad
\delta_{\pi\mathcal F}(\pi(S))=\pi\!\big(\delta_{\mathcal F}(S)\big).
\]

\[
\boxed{\textbf{Target instance}}
\]

\[
[M]=E(B_r(e)),\qquad
\mathcal F=\mathcal T_r(G,e),\qquad
d=k-3.
\]

\[
\boxed{\textbf{Trace family}}
\]

\[
\mathcal T_r(G,e):=
\{\,T_{G,e,[z]}\subseteq E(B_r(e)):\ [z]\in Z_1(G)/Z_1^{\le 2R+1}(G)\setminus\{0\},\ e\in\operatorname{supp}(\operatorname{can}_G([z]))\,\}.
\]

\[
\boxed{\textbf{Required implication}}
\]

\[
\mathrm{VCCL}\wedge \mathrm{OICH}\Longrightarrow \mathrm{BCL}.
\]

\[
\boxed{\textbf{Closure chain}}
\]

\[
\mathrm{BCL}\Longrightarrow \mathrm{ALCL}\Longrightarrow \mathrm{WALPCL}\Longrightarrow \mathrm{ETCL}\Longrightarrow \mathrm{LCB}.
\]

\[
\boxed{\textbf{Terminal obstruction}}
\]

\[
\text{The unique remaining theorem-level compression object is OICH.}
\]

\[
\boxed{\textbf{Good stopping point}}
\]

\[
\text{Structural reduction complete; theorem-certification remains open exactly at OICH.}
\]
