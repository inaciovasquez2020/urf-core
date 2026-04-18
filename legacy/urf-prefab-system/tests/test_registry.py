from src.prefab.registry import PrefabRegistry
from src.prefab.prefab import Prefab

def normalize(x):
    return x

def verify(x):
    return True

def test_registry():
    r = PrefabRegistry()
    p = Prefab("p", None, None, normalize, verify)
    r.register(p)
    assert "p" in r.list()
