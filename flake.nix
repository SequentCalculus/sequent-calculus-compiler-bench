{ 
  description = "Run bash with all dependencies installed";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    effekt.url = "github:jiribenes/effekt-nix";
  };

  outputs = { self, nixpkgs,effekt,... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      effekt-lib = effekt.lib.${system};
      effektVersion = "0.32.0";
      effektBackends = with effekt-lib.effektBackends; [ llvm ];
      effektBuild = effekt-lib.getEffekt { backends = effektBackends; };
    in {
      devShells.${system}.default = pkgs.mkShell{
        buildInputs = [
          #grokking dependencies
          pkgs.yasm
          pkgs.cargo
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

        shellHook= ''
          export name=""
          rm -f Cargo.lock
          '';

      };
    };
}
