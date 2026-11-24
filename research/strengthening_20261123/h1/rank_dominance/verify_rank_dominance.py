#!/usr/bin/env python3
"""Exact nondeterministic exhaustive finite audit of source-defined erasure machine.

Every possible selector choice is enumerated, not just min/max policies.
Guard overruns count as INCOMPLETE. Only Python stdlib.
"""
from itertools import combinations
from time import monotonic

START = monotonic()
DEADLINE = START + 20
MAX_STATE_TRANSITIONS = 300000
transitions = 0
initials = 0
traces_checked = 0
counterexamples = 0
first_terminal_iff_checks = 0
max_live_states = 0

for n in range(7):
    labels = tuple(range(n))
    for size in range(n + 1):
        for tup in combinations(labels, size):
            S0 = frozenset(tup)
            for rank in range(11):
                initials += 1
                states = {S0}
                # Actual operation: r' = max(0, r-1); if S empty stays empty;
                # otherwise erase any currently present element.
                for step in range(max(n, rank) + 3):
                    if monotonic() > DEADLINE or transitions > MAX_STATE_TRANSITIONS:
                        raise SystemExit('INCOMPLETE := RESOURCE_GUARD')
                    r = max(0, rank-step)
                    expected_size = max(0, size-step)
                    for S in states:
                        traces_checked += 1
                        assert len(S) == expected_size, ('CARDINALITY_FORMULA_FAIL', n, tup, rank, step, S)
                        assert (r == 0 and not S) == (step >= max(rank, size)), ('BOTH_ZERO_FORMULA_FAIL', n, tup, rank, step, S)
                        if rank >= size:
                            assert len(S) <= r, ('DOMINANCE_NOT_PRESERVED', n, tup, rank, step, S)
                        if step == rank:
                            first_terminal_iff_checks += 1
                            assert (not S) == (rank >= size), ('SHARP_THRESHOLD_FAILURE', n, tup, rank, step, S)
                        if r == 0 and S:
                            counterexamples += 1
                            assert rank < size
                    max_live_states = max(max_live_states, len(states))
                    successors = set()
                    for S in states:
                        if S:
                            for x in S:
                                successors.add(S - {x})
                                transitions += 1
                        else:
                            successors.add(S)
                            transitions += 1
                    states = successors

print('MODEL := arbitrary selector on a nonempty finite obstruction set')
print('LABEL_SIZES := 0..6')
print('ALL_SUBSETS_PER_LABEL_SIZE := enumerated')
print('INITIAL_RANKS := 0..10')
print('INITIAL_CONFIGURATIONS :=', initials)
print('NONDETERMINISTIC_TRANSITIONS :=', transitions)
print('STATE_TIMES_CHECKED :=', traces_checked)
print('MAX_SIMULTANEOUS_REACHABLE_DATA_SETS :=', max_live_states)
print('REGISTERED_RANK_FORMULA := max(r0-t,0)')
print('DATA_CARDINALITY_FORMULA := max(s0-t,0)')
print('RANK_DOMINANCE_INVARIANT := PASS')
print('FIRST_TERMINAL_SHARP_IFF_CHECKS :=', first_terminal_iff_checks)
print('RANK_ZERO_WITH_DATA_NONEMPTY_EXAMPLES :=', counterexamples)
print('RANK_ZERO_IMPLIES_EMPTY_DATA_FROM_INITIAL_STATE := iff (r0 >= s0)')
print('STATUS := COMPUTATION_PASS (finite range only)')
print('LEAN_VERIFIED := NOT_RUN')
