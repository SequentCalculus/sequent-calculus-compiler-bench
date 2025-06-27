{
  description = "Run bash with all dependencies installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #effekt.url = "github:jiribenes/effekt-nix";
    effekt.url = "github:MarcoTz/effekt-nix";
    scc = {
      url =
        "git+ssh://git@github.com/ps-tuebingen/sequent-calculus-compiler?ref=flake";
    };
  };

  outputs = { self, nixpkgs, effekt, scc, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      effekt-lib = effekt.lib.${system};
      effektBackends = with effekt-lib.effektBackends; [ llvm ];
      effektBuild = effekt-lib.getEffekt { backends = effektBackends; };

      rustPlatform = pkgs.rustPlatform;

      dependencies = [
        pkgs.coreutils
        pkgs.gnumake
        pkgs.cargo
        pkgs.rustc
        pkgs.hyperfine
        scc.packages.${system}.default
        #crate dependencies 
        pkgs.pkg-config
        pkgs.fontconfig
        #languages 
        pkgs.ocaml
        pkgs.koka
        pkgs.smlnj
        pkgs.mlton
        effektBuild
        pkgs.gcc
        pkgs.libuv
        pkgs.gnugrep
        pkgs.gnused
        pkgs.bash
      ];
    in {
      packages.${system}.default = pkgs.rustPlatform.buildRustPackage {
        pname = "Sequent-Calculus-Bench";
        version = "0.1.0";
        src = ./.;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = dependencies;
        propagatedBuildInputs = dependencies;
        cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };
        postFixup = ''
          makeWrapper $out/bin/bench $out/bin/run-bench \
          --set PATH "${pkgs.lib.makeBinPath dependencies}";
        '';

      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ self.packages.${system}.default ];

        shellHook = ''
          export name=""
          echo "Call 'run-bench' to start benchmarks"
        '';

      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/run-bench";
      };

    };
}
