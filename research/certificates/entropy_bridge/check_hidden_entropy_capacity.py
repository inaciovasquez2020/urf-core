#!/usr/bin/env python3
"""Exact kernel/fiber-capacity witness for all F2^n -> F2^m, n,m=1..3.

Standard library only; no downloads, writes or numeric log approximations.
Checks precisely the combinatorial prerequisites for the sharp conditional
entropy theorem; its full entropy inequality is mathematical, not a
computationally certified universal statement.
"""
from itertools import product
from collections import Counter

def main():
    total = injective = noninjective = 0
    max_kernel = 0
    for n in range(1, 4):
        inputs = range(1 << n)
        for m in range(1, 4):
            for matrix_rows in product(inputs, repeat=m):
                outputs = [
                    sum((bin(row & x).count("1") % 2) << i
                        for i, row in enumerate(matrix_rows))
                    for x in inputs
                ]
                fibers = Counter(outputs)
                kernel_card = fibers[0]
                assert kernel_card >= 1
                assert all(v == kernel_card for v in fibers.values())
                assert len(fibers) * kernel_card == (1 << n)
                max_kernel = max(max_kernel, kernel_card)
                if kernel_card == 1:
                    assert len(fibers) == (1 << n)
                    injective += 1
                else:
                    kernel_elements = [x for x, y in enumerate(outputs)
                                       if y == 0]
                    assert len(kernel_elements) == kernel_card
                    assert len(set(kernel_elements)) >= 2
                    # Uniform distribution on two distinct kernel
                    # elements has a single observed output and
                    # exactly two equiprobable remaining inputs.
                    assert outputs[kernel_elements[0]] == 0
                    assert outputs[kernel_elements[1]] == 0
                    noninjective += 1
                total += 1
    assert (total, injective, noninjective, max_kernel) == (
        682, 227, 455, 8)
    print("BINARY_LINEAR_MAPS := ", total, sep="")
    print("INJECTIVE := ", injective, sep="")
    print("NONINJECTIVE := ", noninjective, sep="")
    print("MAX_KERNEL_SIZE := ", max_kernel, sep="")
    print("UNIFORM_FIBERS := COMPUTATION_PASS")
    print("POSITIVE_HIDDEN_ENTROPY_WITNESS := COMPUTATION_PASS")
    print("UNRESTRICTED_LEAN_EQUALITY := OPEN")

if __name__ == "__main__":
    main()
