{
  description = "reth";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    fenix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        system,
        pkgs,
        ...
      }: let
        toolchain = fenix.packages.${system}.stable.withComponents [
            "cargo"       # Cargo package manager
            "rustc"       # Rust compiler
            "clippy"      # Rust linter (optional)
            "rust-src"    # Rust source code needed for bindgen
            "rustfmt"
            "rust-analyzer"
        ];
      in {
        formatter = pkgs.alejandra;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rustPlatform.bindgenHook
          ];
          CFLAGS = "-O2";
          buildInputs =
            (with pkgs; [
              llvmPackages.libclang
            ])
            ++ [toolchain];
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";
        };
      };
    };
}
