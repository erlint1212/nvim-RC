{
  description = "Python environment with pathspec for context_builder.py, plus mdformat with plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3.withPackages (ps: with ps; [
          pathspec
          mdformat
          mdformat-mkdocs
          mdformat-frontmatter
        ]);
      in
      {
        # `nix develop` -> shell with python + pathspec + mdformat (with plugins) on PATH
        devShells.default = pkgs.mkShell {
          packages = [ python ];
        };

        # `nix run` -> runs context_builder.py directly
        packages.default = pkgs.writeShellScriptBin "context-builder" ''
          exec ${python}/bin/python ${./context_builder.py} "$@"
        '';

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/context-builder";
        };
      });
}
