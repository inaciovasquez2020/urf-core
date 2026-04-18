from src.prefab.prefab import Prefab

def normalize(x):
    return sorted(x)

def verify(x):
    return isinstance(x, list)

def test_prefab():
    p = Prefab("sort", list, None, normalize, verify)
    assert p.apply([3,1,2]) == [1,2,3]
