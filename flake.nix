{
  description = "Nix flake for @cyanheads/git-mcp-server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          git-mcp-server = import ./nix/package.nix { inherit pkgs; };
        in
        {
          inherit git-mcp-server;
          default = git-mcp-server;
        });

      apps = forAllSystems (system: {
        git-mcp-server = {
          type = "app";
          program = "${self.packages.${system}.git-mcp-server}/bin/git-mcp-server";
        };
        default = self.apps.${system}.git-mcp-server;
      });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.nodejs
              pkgs.bun
              pkgs.git
            ];
          };
        });
    };
}
