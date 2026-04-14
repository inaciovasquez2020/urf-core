# Perelman Verbatim Normalization Gate

Status: OPEN.

\[
\boxed{\textbf{Perelman Verbatim Normalization Gate}}
\]

\[
\text{Each replay artifact } \mathrm{PL\mbox{-}0001},\dots,\mathrm{PL\mbox{-}0006}
\text{ must eventually carry an exact normalized theorem statement.}
\]

verbatim_source_excerpt

normalized_statement

normalization_notes

internally_verified

\[
\textbf{Required fields for each } \mathrm{PL\mbox{-}000i}:
\quad
\texttt{verbatim\_source\_excerpt},
\ 
\texttt{normalized\_statement},
\ 
\texttt{normalization\_notes}.
\]

\[
\textbf{Promotion rule:}
\quad
\texttt{internally\_verified}
\Rightarrow
\forall i\in\{1,\dots,6\},\
\texttt{verbatim\_source\_excerpt}_i\neq \varnothing
\wedge
\texttt{normalized\_statement}_i\neq \varnothing.
\]
