def canonical_list(x):
    if not isinstance(x, list):
        raise TypeError("Input must be a list")
    return sorted(x)

def canonical_set(x):
    if not isinstance(x, (set, list)):
        raise TypeError("Input must be a set or list")
    return sorted(set(x))
