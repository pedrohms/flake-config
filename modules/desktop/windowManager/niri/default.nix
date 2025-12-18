#  Hyprland configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./niri
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  programs = {
    niri = {
      enable = true;
      useNautilus = true;
    };
  };
  environment.systemPackages = with pkgs; [
    niriswitcher
    xwayland-satellite
    gtklock
    swayidle
  ];
  security.pam.services.gtklock.text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";   
}
