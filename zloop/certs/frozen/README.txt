This directory records the intended frozen-certificate interface.

Contents
hs_cert_interval_P200.json

Current status
No authoritative accepting P200 certificate is established.
The current recomputation gives accept == false.

BOUNDARY := not (S_HS(200) + T_HS(200) < 1)

No Zloop invariant is established at cutoff P = 200.

Reproduction
Run python zloop/scripts/run_certificate_interval.py 200
Compare output JSON byte-for-byte
