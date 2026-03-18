{
  description = "Angular RealWorld Example App development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bun
            nodejs_20
            git
          ];

          shellHook = ''
            echo "🚀 Angular RealWorld Example App"
            echo ""
            echo "Available commands:"
            echo "  bun run setup    # Initialize submodules + install dependencies"
            echo "  bun run start    # Start development server (http://localhost:4200)"
            echo "  bun run build    # Build for production"
            echo ""

            # Check if we're in the project directory
            if [ -f package.json ]; then
              echo "📦 Project detected. Run 'bun run setup' to get started."
            else
              echo "⚠️  Not in project root. Clone the repo first:"
              echo "   git clone https://github.com/realworld-apps/angular-realworld-example-app.git"
            fi

            echo ""
          '';
        };

        # Optional: Package the application
        packages.default = pkgs.stdenv.mkDerivation {
          name = "angular-realworld-example-app";
          src = pkgs.fetchFromGitHub {
            owner = "realworld-apps";
            repo = "angular-realworld-example-app";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
          };

          nativeBuildInputs = with pkgs; [
            bun
            nodejs_20
            git
          ];

          buildPhase = ''
            export HOME=$TMPDIR
            bun run setup
            bun run build
          '';

          installPhase = ''
            mkdir -p $out/share/angular-realworld-example-app
            cp -r dist/* $out/share/angular-realworld-example-app/
          '';
        };
      }
    );
}
