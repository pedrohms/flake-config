
#  Gnome configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./desktopManager
#               └─ ./cosmic
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    desktopManager = {
      cosmic = {
        enable = true;
      };
    };
  };
}
