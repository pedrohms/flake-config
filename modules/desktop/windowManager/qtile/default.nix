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

{ inputs, config, lib, pkgs, myFlakeVersion, ... }:

{
  services = {
    xserver = {
      windowManager.qtile = {
        enable = true;
        package = pkgs.stable.qtile;
        extraPackages = python311Packages: with pkgs.stable.python311Packages; [
          qtile-extras
        ];
      };
      # windowManager.qtile.backend = "x11";
    };
  };
}
