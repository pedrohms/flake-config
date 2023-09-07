#  Gdm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./displayManager
#               └─ ./gdm
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager = {
        gdm = {
          enable = true;
        };
      };
    };
  };
}
