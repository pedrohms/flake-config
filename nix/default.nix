#
# These are the diffent profiles that can be used when building Nix.
#
# flake.nix
#   └─ ./nix
#       └─ default.nix *
#

{ lib, inputs, nixpkgs, home-manager, user, my-overlays, dwl-source, ... }:

let
  system = "x86_64-linux";                                  # System architecture
  pkgs = import nixpkgs {
    inherit system ;
    config.allowUnfree = true;                              # Allow proprietary software
    overlays = my-overlays;
  };
in
{
  desenv07-nix = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays dwl-source; };
    modules = [
      ./desenv07/home.nix
      ./shared
      {
        home = {
          username = "framework";
          homeDirectory = "/home/framework";
          packages = [ pkgs.home-manager ];
          stateVersion = "26.05";
        };
      }
    ];
  };

  notepedro-predator = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays dwl-source; };
    modules = [
      ./notepedro/home.nix
      ./shared
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "26.05";
        };
      }
    ];
  };

  homePedro = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays dwl-source; };
    modules = [
      ./notepedro/home.nix
      ./shared
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "26.05";
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
          username = "vmuser";
          homeDirectory = "/home/vmuser";
          packages = [ pkgs.home-manager ];
          stateVersion = "26.05";
        };
      }
    ];
  };

  homeVmDesktop = home-manager.lib.homeManagerConfiguration {    # Currently only host that can be built
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user pkgs my-overlays dwl-source; };
    modules = [
      ./vmdesktop/home.nix
      {
        home = {
          username = "vmuser";
          homeDirectory = "/home/vmuser";
          packages = [ pkgs.home-manager ];
          stateVersion = "26.05";
        };
      }
    ];
  };
}
