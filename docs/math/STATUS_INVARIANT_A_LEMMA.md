# Status Invariant A Lemma

\[
\boxed{
\operatorname{StatusInvariant}_A(\mathcal P_0)
\;\Leftarrow\;
\operatorname{AuditCoverage}_A(\mathcal P_0)
\wedge
\operatorname{AuditStable}(\mathcal P_0)
\wedge
\operatorname{StatusTruthful}(\mathcal P_0)
}
\]

\[
A=\{
\texttt{docs/math/ECLIPSE_INSTANCE_CERTIFIED_DERIVATION.md}
\}.
\]

\[
\operatorname{AuditCoverage}_A(\mathcal P_0)
:\Longleftrightarrow
\forall p\in A,\ \operatorname{Audited}(p).
\]

\[
\operatorname{StatusInvariant}_A(\mathcal P_0)
:\Longleftrightarrow
\forall p\in A,\ \operatorname{StatusTokenPreserved}(p).
\]

\[
\text{Frontier status}=\text{Conditional}.
\]
