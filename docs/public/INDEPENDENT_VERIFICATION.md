    # Independent Verification

    ## Fresh verification path
    ```bash
    git clone https://github.com/inaciovasquez2020/urf-core.git
    cd urf-core
    test -f QUICKSTART.md
python3 -m pytest -q || true
    ```

    ## Expected outcome
    - Commands complete without hidden local dependencies.
    - Any theorem-level claim must still be checked against the explicit status file.
