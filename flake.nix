{

  description = "lambda rust container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      flake-utils,
      fenix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        overlays = [ fenix.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        pkgs-unstable = import nixpkgs-unstable { inherit system; };
        rust-components = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          #sha256 = pkgs.lib.fakeSha256;
          sha256 = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
        };

        devPackaegs =
          with pkgs;
          [
            awscli2
            fd
            gnused
            rust-components
            nodePackages.typescript-language-server
            just
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ ];

      in
      {
        checks = {
          inherit (craneDrvs.checks) audit;
          typo = pkgs.callPackage ./nix/typo.nix { };
        };

        devShells.default = craneLib.devShell {
          checks = self.checks.${system};
          packages = devPackaegs;
          shellHook = '''';
        };

      }
    );
}
