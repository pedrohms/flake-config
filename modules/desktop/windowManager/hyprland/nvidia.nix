#  Hyprland configuration - enable nvidia patch
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
      enableNvidiaPatches = true;
    };
  };
}
