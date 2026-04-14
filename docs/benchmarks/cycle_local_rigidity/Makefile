.PHONY: benchmark-cycle-rigidity test verify-all

benchmark-cycle-rigidity:
	python3 generate_instances.py
	python3 make_certificates.py
	python3 write_summary.py
	python3 verify_all.py

test:
	python3 -m pytest -q

verify-all:
	python3 verify_all.py
