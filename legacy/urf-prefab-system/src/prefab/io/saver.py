import json

def save_prefab(path, prefab):
    data = {
        "name": prefab.name,
        "inputs": str(prefab.inputs),
        "constraints": str(prefab.constraints)
    }
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
