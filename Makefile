.PHONY: test 
test: 
	cargo test --all --no-fail-fast

.PHONY: bench
bench:
ifeq ($(name),)
	cargo run
else
	cargo run -- -n $(name)
endif
