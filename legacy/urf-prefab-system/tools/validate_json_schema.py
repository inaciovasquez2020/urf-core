import json
import sys
from jsonschema import Draft7Validator

with open("schema/prefab.schema.json") as f:
    schema = json.load(f)

validator = Draft7Validator(schema)

errors = 0
paths = ["docs/EXAMPLE_PREFAB.json"]

for path in paths:
    with open(path) as f:
        data = json.load(f)
    errs = list(validator.iter_errors(data))
    if errs:
        print(f"Schema violations in {path}:")
        for e in errs:
            print("-", e.message)
        errors += 1

if errors:
    sys.exit(1)

print("JSON schema validation passed")
