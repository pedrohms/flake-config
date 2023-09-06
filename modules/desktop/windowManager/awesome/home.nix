#
#  Bspwm Home manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./awesome
#               └─ home.nix *
#

{ config, lib, pkgs, ... }:

{
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager = {
      awesome = {
        enable = true;
      };
    };
  };
}
