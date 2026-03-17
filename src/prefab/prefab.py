class Prefab:
    def __init__(self, name, inputs, constraints, normalize, verify):
        self.name = name
        self.inputs = inputs
        self.constraints = constraints
        self.normalize = normalize
        self.verify = verify

    def apply(self, x):
        if not self.verify(x):
            raise ValueError("Prefab verification failed")
        return self.normalize(x)
