# URF -> DES Marginalized Fisher Object

Status: Conditional.

\[
\boxed{
\textbf{Bridge Closure Step 2}
\quad
\text{Define the marginalized Fisher object for the synthetic injection model.}
}
\]

\[
\boxed{
\Theta=
(\theta_{\mathrm{URF}},\theta_{\mathrm{IA}},\theta_{\mathrm{bar}},\theta_{\mathrm{cal}})
}
\]

\[
\boxed{
d_{\mathrm{syn}}
=
d_0
+
\theta_{\mathrm{URF}}\,u_{\mathrm{URF}}
+
\theta_{\mathrm{IA}}\,u_{\mathrm{IA}}
+
\theta_{\mathrm{bar}}\,u_{\mathrm{bar}}
+
\theta_{\mathrm{cal}}\,u_{\mathrm{cal}}
+
\varepsilon,
\qquad
\varepsilon\sim\mathcal N(0,C_{\mathrm{DES}})
}
\]

\[
\boxed{
F_{ij}
=
u_i^{\!\top} C_{\mathrm{DES}}^{-1} u_j
\qquad
(i,j\in\{\mathrm{URF},\mathrm{IA},\mathrm{bar},\mathrm{cal}\})
}
\]

\[
\boxed{
F=
\begin{pmatrix}
F_{\mathrm{URF},\mathrm{URF}} & F_{\mathrm{URF},N}\\
F_{N,\mathrm{URF}} & F_{N,N}
\end{pmatrix}
\qquad
N=(\mathrm{IA},\mathrm{bar},\mathrm{cal})
}
\]

\[
\boxed{
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}})
=
F_{\mathrm{URF},\mathrm{URF}}
-
F_{\mathrm{URF},N}\,
F_{N,N}^{-1}\,
F_{N,\mathrm{URF}}
}
\]

\[
\boxed{
\textbf{Admissibility gate}
\quad
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}})>0
}
\]

\[
\boxed{
\textbf{Current status}
\quad
\text{Conditional. Marginalized Fisher object defined; numerical evaluation pending.}
}
\]
