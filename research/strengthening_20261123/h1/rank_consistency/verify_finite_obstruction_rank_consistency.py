from itertools import combinations
from hashlib import sha256
from pathlib import Path
import time
started=time.monotonic()
labels=('K5','K33')
subsets=[frozenset(s) for k in range(3) for s in combinations(labels,k)]
max_rank=4
selectors={'lex_first':min,'lex_last':max}
checks=0
terminal_nonempty=[]
one_step_nonempty=[]
consistent_runs=0
for name,choose in selectors.items():
    for data in subsets:
        for rank in range(max_rank+1):
            checks+=1
            terminal=(rank==0)
            if terminal and data: terminal_nonempty.append((name,sorted(data),rank))
            selected=choose(data) if data else None
            next_data=(data-{selected}) if data else data
            next_rank=max(0,rank-1)
            if rank==1 and len(data)==2 and next_rank==0 and next_data:
                one_step_nonempty.append((name,sorted(data),sorted(next_data)))
            if rank==len(data):
                assert next_rank==len(next_data)
                d,r=next_data,next_rank
                for _ in range(rank+1):
                    assert r==len(d)
                    if not d: break
                    d=frozenset(d-{choose(d)})
                    r=max(0,r-1)
                assert not d and r==0
                consistent_runs+=1
    assert time.monotonic()-started<5, 'INCOMPLETE: time guard'
assert checks==40 and len(terminal_nonempty)==6 and len(one_step_nonempty)==2 and consistent_runs==8
print('INPUT_TAGS := K5,K33')
print('SELECTOR_POLICIES := lex_first,lex_last')
print('SUBSETS := 4')
print('REGISTERED_RANKS := 0..4')
print('STATE_POLICY_CHECKS :=',checks)
print('TERMINAL_WITH_NONEMPTY_DATA :=',len(terminal_nonempty))
print('ONE_STEP_REACHES_RANK_ZERO_WITH_NONEMPTY_DATA :=',len(one_step_nonempty))
print('RANK_CARDINALITY_CONSISTENT_INITIAL_STATES :=',consistent_runs)
print('CONSISTENCY_PRESERVED_UNDER_ITERATED_ERASURE := PASS')
print('STATUS := COMPUTATION_PASS (bounded two-tag model; not Lean)')
print('UNIVERSAL_PROOF := Elementary case analysis in research note')
