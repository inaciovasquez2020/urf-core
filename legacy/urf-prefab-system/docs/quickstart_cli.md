URF Prefab System CLI quickstart

Goal
Run the admissibility checker on text and obtain ACCEPT or REJECT.

Install
python -m venv .venv
source .venv/bin/activate
python -m pip install -U pip
python -m pip install -e .

Run
echo "statement to check" | urf-llm-check

Exit codes
0 means ACCEPT
1 means REJECT
2 means INTERNAL ERROR

Contract
Input is plain UTF-8 text on stdin.
Output is exactly one line: ACCEPT or REJECT, plus optional machine-readable diagnostics if enabled by flags.

