# Shadow of Infinity (Canonical Definition)

## Minimal Form

Let
\[
\mathsf A_{\mathrm{fin}}(\mathcal S)=\bigcup_{\kappa<\infty}\mathsf A_\kappa(\mathcal S).
\]

\[
\Sigma_\infty \text{ is a Shadow of Infinity } \iff
\Sigma_\infty \in \overline{\mathsf A_{\mathrm{fin}}(\mathcal S)}
\setminus \mathsf A_{\mathrm{fin}}(\mathcal S).
\]

## Operational Form

\[
\forall \kappa<\infty,\ \Sigma_\infty\notin \mathsf A_\kappa(\mathcal S),
\]
\[
\exists X_n\in \mathsf A_{\kappa_n}(\mathcal S):\ X_n\to \Sigma_\infty.
\]

## Capacity Form

\[
T(\Sigma_\infty)=\infty,\qquad
\forall X\in \mathsf A_{\mathrm{fin}}(\mathcal S),\ T(X)<\infty.
\]

## Defect Certificate

\[
\exists\ \Phi_\infty:\ 
\Phi_\infty(X)>0\ \forall X\in \mathsf A_{\mathrm{fin}},
\]
\[
\inf_{X\in \mathsf A_{\mathrm{fin}}}\Phi_\infty(X)=0,\qquad
\Phi_\infty(\Sigma_\infty)=0.
\]

## Decision Rule

\[
\Sigma_\infty\in \mathsf A_{\mathrm{fin}}
\Rightarrow \texttt{Not Shadow},
\]
\[
\Sigma_\infty\in \overline{\mathsf A_{\mathrm{fin}}}\setminus \mathsf A_{\mathrm{fin}}
\Rightarrow \texttt{Shadow},
\]
\[
\Sigma_\infty\notin \overline{\mathsf A_{\mathrm{fin}}}
\Rightarrow \texttt{Irrelevant}.
\]

## Status

Canonical. Minimal. Toolkit-compatible.
