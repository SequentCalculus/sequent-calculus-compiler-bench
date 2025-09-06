# Benchmarks for "Compiling with the Sequent Calculus"

This repository contains benchmarks for the [Sequent Calculus Compiler (scc)](https://github.com/SequentCalculus/sequent-calculus-compiler/).

## Languages

The benchmarks are implemented in the following languages:

* Fun (the surface language of the above compiler)
* Rust
* SML (using MLton and SML/NJ)
* OCaml
* Effekt
* Koka

## Usage

To install all laguages and run the benchmarks, the provided Nix flake can be used.
This has been tested on x86-64 Linux.
To avoid overflowing the stack, we increase the stack size to 3GB.
With a working Nix installation, with [support for flakes enabled](https://nixos.wiki/wiki/flakes), you can thus simply run (you may need to use `sudo` for the `ulimit` command)

```
ulimit -s 3096000; nix run -i
```

Depending on your system, there may be a hard limit for the stack size and you may need to increase that.
On Linux you can typically do so with `ulimit -Hs 3096000`.

Running the benchmarks takes about 9GB additional memory in the Nix store under `/nix/store`.
If you do not have enough space there, you can specify a path to an alternative chroot store

```
ulimit -s 3096000; nix run -i --store /path/to/chroot-store
```

Depending on your hardware, running the benchmarks may take several hours.
In particular, the `EvenoddGoto` benchmark for SML/NJ and OCaml takes a long time.
To exclude them, you can temprarily rename them with, for example,

```
mv suite/EvenoddGoto/EvenoddGoto.cm suite/EvenoddGoto/EvenoddGoto_cm
mv suite/EvenoddGoto/EvenoddGoto.ml suite/EvenoddGoto/EvenoddGoto_ml
```

The MLton version of this benchmark is already excluded, because it takes very long.

### Results

The raw results will be stored under `results/raw/`.
To obtain graphical representations of the relative speedups on a logarithmic scale with `scc` as the baseline (i.e., above `1` means faster than `scc` and higher is better), you can run

```
make plots
```

The resulting bar plots (SVG) will be stored under `results/plots/`.
