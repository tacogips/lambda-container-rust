{

  description = "lambda rust container";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/d2a93d2fe7820d90eaa10af53891412ec3614f56";
    flake-utils.url = "github:numtide/flake-utils";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane/v0.17.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # Share the patched Node.js and CA bundle across transitive development inputs.
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      fenix,
      pre-commit-hooks,
      crane,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let

        overlays = [ fenix.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-components = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          #sha256 = pkgs.lib.fakeSha256;
          sha256 = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
        };

        craneLib = (crane.mkLib pkgs).overrideToolchain rust-components;

        devPackaegs =
          with pkgs;
          [
            awscli2
            nodejs
            typescript-language-server
            aws-cdk-cli
            just
            taplo
            zip
            nixfmt-rfc-style

            (python3.withPackages (pypkg: [
              pypkg.flake8
              pypkg.pep8-naming
              pypkg.black
            ]))

          ]
          ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ ];

      in
      {

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              rustfmt.enable = true;
              statix.enable = true;
              deadnix.enable = true;
            };
          };
        };

        devShells.default = craneLib.devShell {
          checks = self.checks.${system};
          packages = devPackaegs;
          shellHook = "";
        };

      }
    );
}
