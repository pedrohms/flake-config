#
# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, user, my-overlays, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
    overlays = my-overlays;
  };

  lib = nixpkgs.lib;
in
{
  defaultNix = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    system = "x86_64-linux";
    username = "${user}";
    homeDirectory = "/home/${user}";
    configuration = import ./desenv07/home.nix;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays; };
  };

  homePedro = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    system = "x86_64-linux";
    username = "${user}";
    homeDirectory = "/home/${user}";
    configuration = import ./notepedro/home.nix;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays; };
  };
}
