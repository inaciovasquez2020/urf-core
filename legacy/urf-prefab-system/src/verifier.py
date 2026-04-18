#!/usr/bin/env python3
import json
import sys
from typing import Dict, Any, Set, Tuple

def fail(msg: str) -> None:
    print(f"VERIFY_FAIL: {msg}")
    sys.exit(1)

def load(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def index_prefabs(prefabs) -> Dict[str, Dict[str, Any]]:
    out = {}
    for p in prefabs:
        pid = p["id"]
        if pid in out:
            fail(f"duplicate prefab id: {pid}")
        out[pid] = p
    return out

def sum_Cmax(prefabs) -> float:
    return float(sum(p["C_max"] for p in prefabs))

def sum_Cin(gens) -> float:
    return float(sum(g["C_in"] for g in gens))

def interface_edges(interfaces) -> Set[Tuple[str,str]]:
    return {(x["from"], x["to"]) for x in interfaces}

def assert_kinds(prefab_index: Dict[str, Dict[str, Any]], interfaces) -> None:
    for it in interfaces:
        iid = it["id"]
        if iid not in prefab_index:
            fail(f"interface id not declared as prefab: {iid}")
        if prefab_index[iid]["kind"] != "interface":
            fail(f"prefab {iid} referenced as interface but kind != interface")

def reachable_sinks_from_ast(ast: Dict[str, Any], sinks: Set[str]) -> bool:
    # Minimal conservative check:
    # accept iff at least one sink prefab id appears anywhere in the AST.
    # Tighten later by adding explicit refinement-chain edges.
    stack = [ast]
    while stack:
        node = stack.pop()
        if isinstance(node, dict):
            if node.get("tag") == "Atom" and node.get("id") in sinks:
                return True
            stack.extend(node.values())
        elif isinstance(node, list):
            stack.extend(node)
    return False

def verify(cert: Dict[str, Any]) -> None:
    prefabs = cert["prefabs"]
    interfaces = cert["interfaces"]
    generators = cert["generators"]
    sinks = set(cert["sinks"])
    ast = cert["composition"]["ast"]

    prefab_index = index_prefabs(prefabs)

    # Generator ids must exist and be kind generator
    for g in generators:
        gid = g["id"]
        if gid not in prefab_index:
            fail(f"generator id not declared as prefab: {gid}")
        if prefab_index[gid]["kind"] != "generator":
            fail(f"prefab {gid} referenced as generator but kind != generator")

    # Sink ids must exist and be kind sink
    for sid in sinks:
        if sid not in prefab_index:
            fail(f"sink id not declared as prefab: {sid}")
        if prefab_index[sid]["kind"] != "sink":
            fail(f"prefab {sid} referenced as sink but kind != sink")

    # Interface ids must exist and be kind interface
    assert_kinds(prefab_index, interfaces)

    # Generator budget
    global_budget = float(cert["budgets"]["global_input_budget"])
    total_in = sum_Cin(generators)
    if total_in > global_budget + 1e-12:
        fail(f"generator budget exceeded: sum C_in={total_in} > global_input_budget={global_budget}")

    # Capacity additivity (computed)
    total_C = sum_Cmax(prefabs)
    if total_C < -1e-12:
        fail("total capacity negative")

    # Sink closure (minimal conservative)
    if not reachable_sinks_from_ast(ast, sinks):
        fail("no sink reachable/present in composition AST")

    # No hidden channels cannot be fully decided without an explicit dependency graph.
    # Here we enforce: every Link node in AST must reference a declared interface id.
    def check_links(node):
        if isinstance(node, dict):
            if node.get("tag") == "Link":
                iid = node.get("iface")
                if iid not in prefab_index:
                    fail(f"Link references unknown iface id: {iid}")
                if prefab_index[iid]["kind"] != "interface":
                    fail(f"Link references non-interface prefab as iface: {iid}")
            for v in node.values():
                check_links(v)
        elif isinstance(node, list):
            for v in node:
                check_links(v)
    check_links(ast)

    print("VERIFY_OK")
    print(f"derived_total_capacity_C = {total_C}")
    print(f"derived_total_generator_input = {total_in}")

def main():
    if len(sys.argv) != 2:
        print("usage: verifier.py <certificate.json>")
        sys.exit(2)
    cert = load(sys.argv[1])
    verify(cert)

if __name__ == "__main__":
    main()
