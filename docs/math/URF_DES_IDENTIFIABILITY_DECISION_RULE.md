# URF -> DES Identifiability Decision Rule

Status: Conditional.

\[
\boxed{
\textbf{Bridge Closure Step 3}
\quad
\text{Define the exact decision rule for synthetic identifiability.}
}
\]

\[
\boxed{
\textbf{Inputs}
\quad
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}}),\ 
\rho_{\mathrm{IA}}:=\operatorname{corr}(u_{\mathrm{URF}},u_{\mathrm{IA}}),\ 
\rho_{\mathrm{bar}}:=\operatorname{corr}(u_{\mathrm{URF}},u_{\mathrm{bar}})
}
\]

\[
\boxed{
\textbf{PASS}
\iff
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}})>0
\ \wedge\
\rho_{\mathrm{IA}}<1
\ \wedge\
\rho_{\mathrm{bar}}<1
}
\]

\[
\boxed{
\textbf{FAIL}
\iff
F_{\mathrm{marg}}(\theta_{\mathrm{URF}},\theta_{\mathrm{URF}})=0
\ \vee\
\rho_{\mathrm{IA}}=1
\ \vee\
\rho_{\mathrm{bar}}=1
}
\]

\[
\boxed{
\textbf{Interpretation}
\quad
\text{fit quality alone is non-probative; only identifiable recovery is admissible.}
}
\]

\[
\boxed{
\textbf{Current status}
\quad
\text{Conditional. Decision rule defined; numerical pass/fail evaluation pending.}
}
\]
