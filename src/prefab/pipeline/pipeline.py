class PrefabPipeline:
    def __init__(self, prefabs=None):
        self.prefabs = prefabs or []

    def add(self, prefab):
        self.prefabs.append(prefab)

    def run(self, x):
        result = x
        for prefab in self.prefabs:
            if not prefab.verify(result):
                raise ValueError(f"Verification failed in prefab: {prefab.name}")
            result = prefab.normalize(result)
        return result
