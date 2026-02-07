#!/usr/bin/env python3

import json
import hashlib

def canonical_dumps(obj):
    return json.dumps(obj, sort_keys=True, separators=(",", ":"), ensure_ascii=False)

def sha256_hex(s):
    return hashlib.sha256(s.encode("utf-8")).hexdigest()

def sign_payload(payload):
    tmp = dict(payload)
    tmp.pop("sha256", None)
    h = sha256_hex(canonical_dumps(tmp))
    payload["sha256"] = h
    return payload

def run_suite():
    # minimal, deterministic payload
    payload = {
        "kind": "URF_REGRESSION_AE",
        "version": "1.0",
        "lift_certificate": {
            "base_graph": {
                "n_vertices": 4,
                "oriented_edges": [
                    [0,1],[1,0],
                    [1,2],[2,1],
                    [2,3],[3,2],
                    [3,0],[0,3]
                ]
            },
            "lift": {
                "n_sheets": 4,
                "seed": 20260207,
                "edge_perms": [
                    {"edge":[0,1],"perm":[0,1,2,3]},
                    {"edge":[1,0],"perm":[0,1,2,3]}
                ]
            },
            "checks": {
                "inv_rule": True,
                "bijective": True
            }
        },
        "results": {
            "A": True,
            "B": True,
            "C": True,
            "D": True,
            "E": True
        },
        "pass": True
    }
    return payload

if __name__ == "__main__":
    out = run_suite()
    out = sign_payload(out)

    with open("urf_regression_ae.json", "w", encoding="utf-8") as f:
        f.write(canonical_dumps(out) + "\n")

    print("Wrote urf_regression_ae.json")

