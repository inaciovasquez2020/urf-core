import os
from src.prefab.prefab import Prefab
from src.prefab.io.saver import save_prefab

def normalize(x):
    return x

def verify(x):
    return True

def test_save_prefab(tmp_path):
    p = Prefab("test", None, None, normalize, verify)
    file = tmp_path / "prefab.json"
    save_prefab(file, p)
    assert os.path.exists(file)
