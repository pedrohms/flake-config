#
#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      windowManager= {
        bspwm = {                                 # Window Manager
          enable = true;
        };
      };
    };
  };
}
