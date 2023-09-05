#
#  Qtile configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./qtile
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      windowManager.qtile = {
        enable = true;
        extraPackages = python311Packages: with python311Packages; [
          qtile-extras
        ];
      };
      # windowManager.qtile.backend = "wayland";
    };
  };
}