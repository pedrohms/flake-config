#
#  Dwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./windowManager
#               └─ ./dwm
#                   └─ default.nix *
#

{ config, lib, pkgs, myFlakeVersion, ... }:
let
  localPkgs = import ../../../packages/default.nix { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };
  customPackages = with localPkgs; [
    dwm
    dwmblocks
  ];
in 
{
  services = {
    xserver = {
      windowManager = {
        dwm = {                                 # Window Manager
          enable = true;
        };
      };
    };
  };

  environment.systemPackages = customPackages;
}
