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
    inherit system ;
    config.allowUnfree = true;                              # Allow proprietary software
    overlays = my-overlays;
  };
in
{
  desenv07 = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays; };
    modules = [
      ./desenv07/home.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "23.11";
        };
      }
    ];
  };

  homePedro = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays; };
    modules = [
      ./notepedro/home.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "23.11";
        };
      }
    ];
  };

  homeVm = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays; };
    modules = [
      ./vm/home.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "23.11";
        };
      }
    ];
  };
}
