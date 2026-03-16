let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  nixpkgsNode = lock.nodes.nixpkgs.locked;
  pkgs = import (fetchTarball {
    url = "https://github.com/${nixpkgsNode.owner}/${nixpkgsNode.repo}/archive/${nixpkgsNode.rev}.tar.gz";
    sha256 = nixpkgsNode.narHash;
  }) {
    system = builtins.currentSystem;
  };
in
(import ./nix/package.nix { inherit pkgs; })
