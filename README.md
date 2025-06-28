# Benchmarks for "Compiling Through Sequent Calculus"

This repository contains benchmarks for [Compiling with the Sequent Calculus](https://github.com/ps-tuebingen/sequent-calculus-compiler/).

## Languages

The benchmarks are implemented in the following languages 

* Fun (the surface language of the above compiler)
* Rust
* SML (using MLton and SML/NJ)
* OCaml
* Effekt
* Koka

## Usage

To install all laguages and run the benchmarks, the provided Nix flake can be used.
As some language overflow the stack for some benchmark programs, we increase the stack size to 2GB.
With working Nix installation, simply run

```
ulimit -s 2048000; nix run -i
```

This takes about 9GB additional memory in the Nix store under `/nix/store`.
If you do not have enough space there, you can specify a path to an alternative chroot store

```
ulimit -s 2048000; nix run -i --store /path/to/chroot-store
```
