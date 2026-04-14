# Star Stellar Coercivity Split

Conditional.

\[
\boxed{
\textbf{Star Stellar Coercivity Split}
}
\]

\[
\Phi_\star(D_\star)=\frac12\|D_\star-D_\star^\ast\|^2,
\qquad
u:=D_\star-D_\star^\ast.
\]

\[
F_\star(D_\star)=L_\star u+N_\star(u).
\]

\[
\textbf{Target theorem: }
\exists\,\beta\ge 0\ \forall D_\star\text{ admissible},
\qquad
\langle \nabla\Phi_\star(D_\star),F_\star(D_\star)\rangle
\le
\beta \Phi_\star(D_\star).
\]

\[
\textbf{Current reduction:}
\]

\[
\textbf{R1A.}
\quad
\exists\,\beta_0\ge 0\ \forall u,
\qquad
\langle u,L_\star u\rangle\le \beta_0\|u\|^2.
\]

\[
\textbf{R1B.}
\quad
\exists\,c_N\ge 0\ \forall u\text{ admissible},
\qquad
\|N_\star(u)\|\le c_N\|u\|.
\]

\[
\Rightarrow
\langle \nabla\Phi_\star,F_\star\rangle
\le
2(\beta_0+c_N)\Phi_\star.
\]

\[
\textbf{Exact remaining theorem objects:}
\]

\[
\text{(1a) choose the precise linearization }L_\star=dF_\star|_{D_\star^\ast};
\]

\[
\text{(1b) compute or bound the symmetric part }
\frac{L_\star+L_\star^\ast}{2};
\]

\[
\text{(1c) prove }
\sup_{\|u\|=1}\langle u,L_\star u\rangle\le \beta_0;
\]

\[
\text{(1d) prove a neighborhood Lipschitz/Taylor remainder estimate }
\|F_\star(D_\star^\ast+u)-F_\star(D_\star^\ast)-L_\star u\|
\le
c_N\|u\|.
\]
