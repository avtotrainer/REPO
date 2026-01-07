{
  description = "JPL — Local Jekyll build, static deploy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # ─────────────────────────────────────────────
    # Development shell (editor, bundix, etc.)
    # ─────────────────────────────────────────────
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.ruby
        pkgs.bundix
      ];
    };

    # ─────────────────────────────────────────────
    # Build output (Jekyll → static HTML)
    # ─────────────────────────────────────────────
    packages.${system}.default =
      pkgs.stdenv.mkDerivation {
        pname = "jpl-site";
        version = "1.0.0";

        src = ./src;

        nativeBuildInputs = [
          pkgs.jekyll
        ];

        buildPhase = ''
          jekyll build --source . --destination $out
        '';

        installPhase = "true";
      };

    # ─────────────────────────────────────────────
    # THIS IS THE KEY PART
    # Enables: `nix build` → ./result
    # ─────────────────────────────────────────────
    defaultPackage.${system} =
      self.packages.${system}.default;
  };
}

