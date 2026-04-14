# Finite-Type Spectral Separation Target

Status: OPEN.

\[
\boxed{
\begin{minipage}{0.93\linewidth}
\textbf{Finite-Type Spectral Separation Theorem.}

Let
\[
\mathcal T_{k,\Delta,R}=\{\,\tau_1,\dots,\tau_N\,\}
\]
be the finite set of rooted radius-\(R\) \(k\)-types of connected graphs of maximum degree \(\le \Delta\). For each finite connected graph \(G\) of maximum degree \(\le\Delta\), let
\[
\pi_{G,R}\in \Delta(\mathcal T_{k,\Delta,R})
\]
be the empirical rooted-type distribution, and let
\[
L_{G,R}\in \mathrm{Sym}_N(\mathbb R)
\]
be the canonical self-adjoint finite-type transition operator extracted from the rooted radius-\(R\) adjacency transport on \(\mathcal T_{k,\Delta,R}\).

Define
\[
Q_R(G):=Z_1(G)/Z_1^{\le 2R+1}(G).
\]

Then there exist constants
\[
\varepsilon=\varepsilon(k,\Delta,R)>0,\qquad C=C(k,\Delta,R)<\infty
\]
such that for every finite connected \(G\) with
\[
\dim_{\mathbb F_2}Q_R(G)\ge C,
\]
the restricted operator
\[
L_{G,R}\big|_{\mathbf 1^\perp}
\]
has spectral gap at least \(\varepsilon\), i.e.
\[
\lambda_2(L_{G,R})\ge \varepsilon,
\]
equivalently,
\[
\forall v\in \mathbf 1^\perp\setminus\{0\},\qquad
\frac{\langle L_{G,R}v,v\rangle}{\|v\|^2}\ge \varepsilon
\]
for some nonzero \(v\in\mathbf 1^\perp\).

Abbreviation:
\[
\mathrm{FSS}(k,\Delta,R).
\]

FSS(k,\Delta,R)

lambda := \lambda_2(L_{G,R})
\end{minipage}
}
\]
