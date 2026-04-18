def is_canonical_list(x):
    return isinstance(x, list) and x == sorted(x)

def unique_list(x):
    return sorted(set(x))
