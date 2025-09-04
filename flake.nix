{
  description = "Run bash with all dependencies installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    #effekt.url = "github:jiribenes/effekt-nix";
    effekt.url = "github:MarcoTz/effekt-nix";
    scc = {
      url =
        "git+ssh://git@github.com/ps-tuebingen/sequent-calculus-compiler";
    };
  };

  outputs = { self, nixpkgs, flake-utils, effekt, scc, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        effekt-lib = effekt.lib.${system};
        effektBackends = with effekt-lib.effektBackends; [ llvm ];
        effektBuild = effekt-lib.getEffekt { backends = effektBackends; };
        rustPlatform = pkgs.rustPlatform;
        dependencies = [
          #compilers
          pkgs.ocaml
          pkgs.koka
          pkgs.smlnj
          pkgs.mlton
          effektBuild
          scc.packages.${system}.default
          pkgs.rustc

          #required by rustc
          pkgs.gcc
          #required by smlnj
          pkgs.gnugrep
          pkgs.gnused
          #required by mlton
          pkgs.coreutils

          #hyperfine
          pkgs.hyperfine
          pkgs.bash
        ];
      in {
        packages = {
          sccBench = pkgs.rustPlatform.buildRustPackage {
            pname = "Sequent-Calculus-Bench";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.makeWrapper pkgs.pkgconf ];
            buildInputs = dependencies ++ [ pkgs.fontconfig pkgs.expat ];
            cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };
            postFixup = ''
              makeWrapper $out/bin/bench $out/bin/run-bench \
              --set PATH "${pkgs.lib.makeBinPath dependencies}";
              '';
        };
        default=self.packages.${system}.sccBench;
      };

      devShells = {
        sccShell = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.default ];

          shellHook = ''
            export name=""
            echo "Call 'run-bench' to start benchmarks"
            '';
        };
        default=self.devShells.${system}.sccShell;
      };

      apps = {
        sccApp = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/run-bench";
        };
        default = self.apps.${system}.sccApp;
      };
  }); 
}
