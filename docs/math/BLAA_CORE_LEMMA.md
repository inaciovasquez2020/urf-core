# BLAA_CORE_LEMMA

Status: CONDITIONAL.

\[
\boxed{
\textbf{Sector-Deletion Preservation Lemma (BlAA-Core)}
}
\]

\[
\forall k,\Delta,R\ \exists B_{0}=B_{0}(k,\Delta,R)\in\mathbb N
\]

\[
\forall G\in\mathcal H_{k,\Delta,R}\ \forall z\neq 0\in Z_{1}(G)/Z_{1}^{\le 2R+1}(G)\ \forall W\subseteq G,
\]

\[
\operatorname{AdmWitness}_{k,\Delta,R}(G,z,W)\ \wedge\ |\partial W|>B_{0}
\]

\[
\Longrightarrow
\exists x\neq y\in\partial W
\]

\[
\Big(
\operatorname{tp}^{R}_{\mathrm{FO}^{k}}(W,x),
\operatorname{Inc}_{W}(x),
\operatorname{CycleSig}_{W}(x)
\Big)
=
\Big(
\operatorname{tp}^{R}_{\mathrm{FO}^{k}}(W,y),
\operatorname{Inc}_{W}(y),
\operatorname{CycleSig}_{W}(y)
\Big)
\]

\[
\Rightarrow
\exists \Psi_{y}(W)=W\setminus S_{y}
\]

\[
\operatorname{AdmWitness}_{k,\Delta,R}(G,z,\Psi_{y}(W))
\]

\[
\wedge\
z(\Psi_{y}(W))=z(W)
\]

\[
\wedge\
\Big(
\operatorname{tp}^{R}_{\mathrm{FO}^{k}}(\Psi_{y}(W)),
\operatorname{Inc}(\Psi_{y}(W)),
\operatorname{CycleSig}(\Psi_{y}(W))
\Big)
=
\Big(
\operatorname{tp}^{R}_{\mathrm{FO}^{k}}(W),
\operatorname{Inc}(W),
\operatorname{CycleSig}(W)
\Big)
\]

\[
\wedge\
\mathsf{size}(\Psi_{y}(W))<\mathsf{size}(W).
\]

\[
\boxed{
\textbf{Closure consequences}
}
\]

\[
\textnormal{BlAA-Core}
\Longrightarrow
\textnormal{bounded-interface extraction}
\Longrightarrow
\textnormal{finite-type bound}
\Longrightarrow
MLG
\Longrightarrow
MCR
\]

\[
\wedge
\]

\[
\textnormal{finite type graph}
\Longrightarrow
TTC
\Longrightarrow
FSS
\]

\[
\Longrightarrow
\textnormal{Global Coercivity}
\Longrightarrow
\textnormal{Unconditional Closure}.
\]
