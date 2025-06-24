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

      dependencies = [
        pkgs.coreutils
        pkgs.gnumake
        pkgs.cargo
        pkgs.yasm
        pkgs.cargo
        pkgs.hyperfine
        scc.packages.${system}.default
        #crate dependencies 
        pkgs.gcc
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
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        name = "run-hyperfine";
        buildInputs = [ pkgs.makeWrapper ];
        src = null;
        unpackPhase = "true";
        buildPhase = "true";
        installPhase = ''
          mkdir -p $out/bin
          OUT=$out/bin/run.sh
          echo "#!/bin/bash" > $OUT
          echo "effekt -b --backend llvm suite/FactorialAccumulator/FactorialAccumulator.effekt" >> $OUT
          echo "ulimit -s unlimited && cargo run" >> $OUT
          chmod +x $OUT
        '';

        postFixup = ''
          wrapProgram $out/bin/run.sh \
            --set PATH ${pkgs.lib.makeBinPath dependencies}
        '';
        #[pkgs.lib.makeLibraryPath [pkgs.libuv]}

      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = dependencies;

        shellHook = ''
          export name=""
        '';

      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/run.sh";
      };

    };
}
