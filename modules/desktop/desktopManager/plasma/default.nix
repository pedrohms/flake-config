#  Plasma configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./desktopManager
#               └─ ./plasma
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  programs = {
    kdeconnect.enable = true;
  };
  services = {
    xserver = {
      desktopManager = {
        plasma6 = {
          enable = true;
          # useQtScaling = true;
        };
      };
    };
  };
}
