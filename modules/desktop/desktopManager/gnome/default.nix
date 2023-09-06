#  Gnome configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./desktopManager
#               └─ ./gnome
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };
  };
}
