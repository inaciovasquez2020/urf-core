from src.prefab.prefab import Prefab
from src.prefab.pipeline.pipeline import PrefabPipeline

def normalize(x):
    return sorted(x)

def verify(x):
    return isinstance(x, list)

def test_pipeline():
    p = Prefab("sort", list, None, normalize, verify)
    pipeline = PrefabPipeline([p])
    assert pipeline.run([3,1,2]) == [1,2,3]
