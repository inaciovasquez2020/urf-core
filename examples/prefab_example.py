from src.prefab.prefab import Prefab
from src.prefab.registry import PrefabRegistry
from src.prefab.normalize import canonical_list

def verify(x):
    return isinstance(x, list)

registry = PrefabRegistry()

sort_prefab = Prefab(
    name="canonical_sort",
    inputs=list,
    constraints=None,
    normalize=canonical_list,
    verify=verify
)

registry.register(sort_prefab)

print(registry.get("canonical_sort").apply([5,3,4,1]))
