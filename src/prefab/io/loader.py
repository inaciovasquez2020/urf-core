import json
from src.prefab.prefab import Prefab

def load_prefab(path, normalize, verify):
    with open(path, "r") as f:
        data = json.load(f)
    name = data.get("name")
    inputs = data.get("inputs")
    constraints = data.get("constraints")
    return Prefab(name, inputs, constraints, normalize, verify)
