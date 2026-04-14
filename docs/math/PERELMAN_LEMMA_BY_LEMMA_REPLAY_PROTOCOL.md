# Perelman Lemma-by-Lemma Replay Protocol

Conditional.

\[
\boxed{
\textbf{Target}
\quad
\text{Lemma-by-lemma internal replay of the Perelman/Morgan--Tian/Kleiner--Lott proof path for Poincaré.}
}
\]

\[
\boxed{
\textbf{Replay Object}
\quad
\mathcal R=(L,S,D,G,C)
}
\]

\[
L=\text{lemma inventory},
\quad
S=\text{source map},
\quad
D=\text{dependency DAG},
\quad
G=\text{gap ledger},
\quad
C=\text{closure report}.
\]

\[
\boxed{
\textbf{Admissibility Rule}
}
\]

\[
\texttt{Internally\ Verified}
\Rightarrow
\forall \ell\in L,\ \texttt{status}(\ell)=\texttt{verified}
\]
\[
\wedge\ D\ \text{acyclic}
\wedge\ G=\varnothing
\wedge\ C.\texttt{replay\_complete}=\texttt{true}.
\]

\[
\boxed{
\textbf{Lemma Record Schema}
}
\]

\[
\ell=(\texttt{id},\texttt{section},\texttt{statement},\texttt{source},\texttt{source\_locator},\texttt{dependencies},\texttt{status},\texttt{notes})
\]

\[
\texttt{status}\in\{\texttt{open},\texttt{replayed},\texttt{blocked},\texttt{verified}\}.
\]

\[
\boxed{
\textbf{Promotion Rule}
}
\]

\[
C.\texttt{internal\_verification}=\texttt{internally\_verified}
\Rightarrow
\forall \ell\in L,\ \texttt{status}(\ell)=\texttt{verified}.
\]
