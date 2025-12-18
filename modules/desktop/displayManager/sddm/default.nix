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
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };
  };
}
