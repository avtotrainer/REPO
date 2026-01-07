{
  description = "JPL Jekyll build environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.ruby
        pkgs.bundix
      ];
    };

    packages.${system}.default =
      pkgs.stdenv.mkDerivation {
        name = "jpl-site";
        src = ./src;

        nativeBuildInputs = [
          pkgs.jekyll
        ];

        buildPhase = ''
          jekyll build -s . -d $out
        '';

        installPhase = "true";
      };
  };
}

