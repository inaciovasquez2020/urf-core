class PrefabRegistry:
    def __init__(self):
        self._registry = {}

    def register(self, prefab):
        name = prefab.name
        if name in self._registry:
            raise ValueError(f"Prefab '{name}' already registered")
        self._registry[name] = prefab

    def get(self, name):
        return self._registry.get(name)

    def list(self):
        return list(self._registry.keys())
