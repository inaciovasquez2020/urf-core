#!/usr/bin/env python3
"""Bounded exact symmetry-reduced FO^k pebble-game checker on complete graphs.

Pure undirected loopless adjacency E(u,v) iff u != v, equality, no counting,
no named vertices, no order or colors. Only finite computational evidence.
No dependencies outside Python stdlib. Resource guard => INCOMPLETE, never PASS.
"""
import argparse
import time

class ResourceLimit(Exception):
    pass

def canonical(state):
    """Represent a partial variable assignment by restricted-growth labels."""
    labels = {}
    output = []
    for x in state:
        if x == -1:
            output.append(-1)
        else:
            if x not in labels:
                labels[x] = len(labels)
            output.append(labels[x])
    return tuple(output)

def successors(state, i, size):
    """All equality patterns after rebinding variable i in K_size."""
    other = list(state)
    other[i] = -1
    occupied = {a for a in other if a >= 0}
    targets = set(occupied)
    if len(occupied) < size:
        targets.add(max(occupied, default=-1) + 1)
    result = set()
    for target in targets:
        new = other[:]
        new[i] = target
        result.add(canonical(new))
    return result

def universe(k, size, deadline, max_states):
    initial = (-1,) * k
    visited = {initial}
    frontier = [initial]
    while frontier:
        if time.monotonic() > deadline or len(visited) > max_states:
            raise ResourceLimit('state enumeration')
        state = frontier.pop()
        for i in range(k):
            for successor in successors(state, i, size):
                if successor not in visited:
                    visited.add(successor)
                    frontier.append(successor)
    return visited

def infinite_game(k, a, b, deadline, max_states):
    """Greatest-fixed-point back-and-forth test on canonical equality states."""
    sa = universe(k, a, deadline, max_states)
    sb = universe(k, b, deadline, max_states)
    candidates = sa & sb
    iterations = 0
    while True:
        if time.monotonic() > deadline:
            raise ResourceLimit('fixed-point iteration')
        kept = set()
        for state in candidates:
            if time.monotonic() > deadline:
                raise ResourceLimit('fixed-point enumeration')
            if all(successors(state, i, a) <= candidates and
                   successors(state, i, b) <= candidates for i in range(k)):
                kept.add(state)
        if kept == candidates:
            return ((-1,) * k in kept, len(sa), len(sb), len(kept), iterations)
        candidates = kept
        iterations += 1

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--max-k', type=int, default=6)
    p.add_argument('--seconds', type=float, default=30)
    p.add_argument('--max-states', type=int, default=20000)
    args = p.parse_args()
    if not 1 <= args.max_k <= 8 or args.seconds <= 0 or args.max_states < 100:
        raise SystemExit('INVALID_BOUNDS')
    deadline = time.monotonic() + args.seconds
    print('MODEL := loopless complete graphs, equality + adjacency, pure FO^k')
    print('ALGORITHM := exact canonical equality-pattern greatest fixed point')
    print('PARAMETERS :=', vars(args))
    for k in range(1, args.max_k+1):
        try:
            win, sa, sb, count, rounds = infinite_game(k, k, k+1, deadline, args.max_states)
            if not win:
                raise RuntimeError(f'positive control FAILED at k={k}')
            print(f'K_{k}_K_{k+1} := EQUIVALENT k={k} patterns={sa}/{sb} winning={count} iterations={rounds}')
            if k >= 2:
                win, _, _, _, rounds = infinite_game(k, k-1, k, deadline, args.max_states)
                if win:
                    raise RuntimeError(f'negative control FAILED at k={k}')
                print(f'K_{k-1}_K_{k} := DISTINGUISHABLE k={k} iterations={rounds}')
        except ResourceLimit as e:
            print(f'INCOMPLETE := k={k} {e}')
            return 2
    print('RESULT := COMPUTATION_PASS (bounded finite game certificate)')
    print('UNBOUNDED_THEOREM := PAPER_PROOF_ONLY')
    print('LEAN := NOT_RUN')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
