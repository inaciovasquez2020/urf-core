# URF-11 Weak Interaction Theorem

## Status
OPEN

## Setup
Let G=(F,E), where (F_i,F_j) in E iff there exists a bridge packet Pi_{i->j} with V_bridge(Pi_{i->j})=1.

## Statement
If for every i there exists j != i with V_bridge(Pi_{i->j})=1, then deg^+(F_i) >= 1 for all i and I(U_11) >= 11.

## Consequence
Every field lies on at least one outward interaction path.

## Finish condition
Replace OPEN by PROVED only after repository-native tests certify one valid outgoing bridge packet for each field.
