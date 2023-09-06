#  Lightdm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./displayManager
#               └─ ./lightdm
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager = {
        sddm = {
          enable = true;
          autoNumLock = true;
        };
      };
    };
  };
}