#
# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, user, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  homePedro = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    system = "x86_64-linux";
    username = "${user}";
    homeDirectory = "/home/${user}";
    configuration = import ./pacman.nix;
    extraSpecialArgs = { inherit inputs user pkgs; };
  };
}
