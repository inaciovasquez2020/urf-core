.PHONY: urf-style
urf-style:
	./tools/build_my_work.sh

.PHONY: verify

verify:
	./tools/trust_verify.sh
