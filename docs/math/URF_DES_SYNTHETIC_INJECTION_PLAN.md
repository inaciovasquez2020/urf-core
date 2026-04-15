# URF -> DES Synthetic Injection Plan

Status: Conditional.

\[
\boxed{
\textbf{Bridge Closure Step 1}
\quad
\text{Define the minimal synthetic injection-recovery object.}
}
\]

\[
\boxed{
\textbf{Synthetic parameter block}
\quad
\Theta=
(\theta_{\mathrm{URF}},\theta_{\mathrm{IA}},\theta_{\mathrm{bar}},\theta_{\mathrm{cal}})
}
\]

\[
\boxed{
\textbf{Synthetic data model}
\quad
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
\textbf{Recovery criterion}
\quad
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}})>0
}
\]

\[
\boxed{
\textbf{Orthogonality screen}
\quad
\operatorname{corr}(u_{\mathrm{URF}},u_{\mathrm{IA}})<1
\ \wedge\
\operatorname{corr}(u_{\mathrm{URF}},u_{\mathrm{bar}})<1
}
\]

\[
\boxed{
\textbf{Current status}
\quad
\text{Conditional. Synthetic injection object defined; recovery execution pending.}
}
\]
