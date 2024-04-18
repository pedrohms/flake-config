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
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
    };
  };
  environment.systemPackages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprland-contrib.packages.${pkgs.system}.hyprprop
    inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
    inputs.hyprland-contrib.packages.${pkgs.system}.shellevents
    pkgs.hyprpicker
    pkgs.hyprpaper
    pkgs.pyprland
  ];
}
