stack_size = 2048000

.PHONY: test 
test: 
	ulimit -s $(stack_size) && cargo test --all --no-fail-fast

.PHONY: bench
bench:
ifeq ($(name),)
	ulimit -s $(stack_size) && cargo run
else
	ulimit -s $(stack_size) && cargo run -- -n $(name)
endif

.PHONY: clean
clean:
	find -name "*.cmi" -delete
	find -name "*.cmo" -delete
