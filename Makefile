stack_size = 3584000

.PHONY: test 
test: 
ifeq ($(name),)
	ulimit -s $(stack_size) && cargo test --all --no-fail-fast
else 
	ulimit -s $(stack_size) && cargo test -p testsuite --test test-single -- $(name)
endif

.PHONY: check
check:
	cargo fmt --all -- --check
	cargo clippy

.PHONY: bench
bench:
ifeq ($(name),)
	ulimit -s $(stack_size) && cargo run
else
	ulimit -s $(stack_size) && cargo run -- -n $(name)
endif

.PHONY: plots
plots:
	cargo run -p report

.PHONY: clean
clean:
	find -name "*.cmi" -delete
	find -name "*.cmo" -delete
	find -name "*.cmx" -delete
	find -name "*.o" -delete
	find -name ".cm" -type d | xargs rm -r 
	find -name ".koka" -type d | xargs rm -r 
