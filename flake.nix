{
  description = "Minimal Jekyll site build with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default =
        pkgs.stdenv.mkDerivation {
          name = "jekyll-site";
          src = ./src;

          buildInputs = [
            pkgs.ruby
            pkgs.rubyPackages.jekyll
          ];

          buildPhase = ''
            jekyll build --source . --destination $out
          '';

          installPhase = "true";
        };
    };
}

