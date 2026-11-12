"""Exhaustive finite certificate: observable-state identifiability.

Toy models only; no psychological or clinical validation is claimed.
Run: python3 -m pytest -q tests/test_f10_observational_identifiability.py
"""
from itertools import product

STATES = range(3)
BINARY_MAPS = tuple(product(range(2), repeat=3))


def fiber_constant(observations, target):
    return all(observations[x] != observations[y] or target[x] == target[y]
               for x in STATES for y in STATES)


def decoder_exists(observations, target, alphabet):
    # Independent exhaustive search over every possible decoder.
    return any(all(decoder[observations[x]] == target[x] for x in STATES)
               for decoder in product(range(2), repeat=alphabet))


def test_single_observation_exhaustive():
    count = 0
    for obs in BINARY_MAPS:
        for target in BINARY_MAPS:
            assert fiber_constant(obs, target) == decoder_exists(obs, target, 2)
            count += 1
    assert count == 64


def test_intervention_augmented_observation_exhaustive():
    count = 0
    recovered = 0
    for obs in BINARY_MAPS:
        for intervention_outcome in BINARY_MAPS:
            joint = tuple(2 * obs[x] + intervention_outcome[x] for x in STATES)
            for target in BINARY_MAPS:
                expected = fiber_constant(joint, target)
                assert expected == decoder_exists(joint, target, 4)
                # An extra measurement cannot destroy existing identifiability.
                assert not fiber_constant(obs, target) or expected
                recovered += int(not fiber_constant(obs, target) and expected)
                count += 1
    assert count == 512
    assert recovered > 0


def test_intervention_can_resolve_collision():
    obs = (0, 0, 1)
    target = (0, 1, 1)
    intervention = (0, 1, 0)
    joint = tuple(2 * obs[x] + intervention[x] for x in STATES)
    assert not decoder_exists(obs, target, 2)
    assert decoder_exists(joint, target, 4)


def test_intervention_can_fail_to_resolve_collision():
    obs = (0, 0, 1)
    target = (0, 1, 1)
    intervention = (1, 1, 0)
    joint = tuple(2 * obs[x] + intervention[x] for x in STATES)
    assert not decoder_exists(joint, target, 4)
