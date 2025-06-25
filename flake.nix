{
  description = "Run bash with all dependencies installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    effekt.url = "github:jiribenes/effekt-nix";
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
        #effekt dependency
        pkgs.libuv
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
        buildInputs = dependencies ++ [ self.packages.${system}.default ];

        shellHook = ''
          export name=""
        '';

      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/run-bench";
      };

    };
}
