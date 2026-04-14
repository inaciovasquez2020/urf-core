# Remaining Mathematical Closure — Final Reduced Form

## Status
Conditional.

\[
\boxed{
\textbf{Terminal Reduction}
}
\]

\[
\Gamma(F_\star,\nu;D)
=
\Gamma_{\mathrm{spec}}(D)
+
\Gamma_{\mathrm{meas}}(D)
\]

\[
\boxed{
\Gamma(F_\star,\nu;D)\ge c_R\,\mathcal O_R(D)
}
\]

---

## Final Two Theorem Objects

### (A) Spectral Separation

\[
\exists\,a_R>0
\quad
\forall \tau\neq\tau',
\quad
\inf_{\substack{x\in\mathcal H_\tau,\ y\in\mathcal H_{\tau'}\\ x+y\neq 0}}
\frac{
\langle L_\star(x+y),x+y\rangle
}{
\|x+y\|^2
}
\ge a_R
\]

\[
\Longrightarrow
\Gamma_{\mathrm{spec}}(D)\ge a_R\,\mathcal O_R^{\mathrm{type}}(D)
\]

---

### (B) Measure–Cycle Coercivity

\[
\exists\,b_R>0
\quad
\forall D\in\mathcal A,
\quad
\Gamma_{\mathrm{meas}}(D)\ge b_R\,\mathcal O_R^{\mathrm{cycle}}(D)
\]

---

## Combined Closure

\[
\boxed{
\min(a_R,b_R)>0
\Longrightarrow
\Gamma(F_\star,\nu;D)\ge c_R\,\mathcal O_R(D)
}
\]

---

## Interpretation

\[
\text{Closure reduces to two independent coercivity sources:}
\]

\[
\text{(1) Finite-type spectral separation}
\quad
\text{(2) Cycle-complexity measure rigidity}
\]

---

## Frontier Status

\[
\text{Spectral separation}=\text{open}
\]

\[
\text{Measure-cycle coercivity}=\text{open}
\]

\[
\text{Global coercivity}=\text{conditional}
\]

## Terminal Theorem Objects

\[
\boxed{
\mathbf{SS}=\text{Finite-type spectral separation}
}
\]

\[
\boxed{
\mathbf{MC}=\text{Measure-cycle coercivity}
}
\]

\[
\boxed{
(\mathbf{SS}\wedge \mathbf{MC})\Rightarrow \text{Global coercivity}.
}
\]

## Next Benchmark-Level Sub-Lemmas

\[
\boxed{
\mathbf{SSW}=\text{benchmark witness-sequence exclusion under }\mathbf{SS}
}
\]

\[
\boxed{
\mathbf{LCRB}_{\mathcal B}=\text{benchmark-family local cycle-rank bound under }\mathbf{LCRB}
}
\]

\[
\boxed{
\mathbf{SSW}\Rightarrow \text{benchmark support for }\mathbf{SS}
}
\]

\[
\boxed{
\mathbf{LCRB}_{\mathcal B}\Rightarrow \text{benchmark support for }\mathbf{LCRB}
}
\]

## Benchmark Estimator / Surrogate Layer

\[
\boxed{
\widehat{\lambda}_{\mathrm{sep}}^{\mathcal B}
=
\text{locked estimator under }\mathbf{SSW}
}
\]

\[
\boxed{
\widehat{C}_2^{\mathcal B}
=
\text{locked surrogate under }\mathbf{LCRB}_{\mathcal B}
}
\]

\[
\boxed{
\text{Empirical promotion of }\mathbf{SSW}\text{ or }\mathbf{LCRB}_{\mathcal B}\text{ is not admissible without a theorem bridge.}
}
\]

## Theorem Bridge Axiom

\[
\boxed{
\mathbf{TBA}:\ 
\widehat{\lambda}_{\mathrm{sep}}^{\mathcal B}
\Rightarrow
\lambda_{\mathrm{sep}}
}
\]
