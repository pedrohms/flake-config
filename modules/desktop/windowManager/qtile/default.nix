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
        package = pkgs.python3Packages.qtile;
        extraPackages = python311Packages: with pkgs.python311Packages; [
          pkgs.python3Packages.qtile-extras
          cairocffi
          mypy
        ];
      };
      windowManager.qtile.backend = "x11";
    };
  };
}
