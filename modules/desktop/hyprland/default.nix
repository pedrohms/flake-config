#  Hyprland configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      enableNvidiaPatches = true;
    };
  };
}
