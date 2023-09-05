#
#  Dwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./dwm
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:
let
  # dwm = pkgs.dwm.overrideAttrs (oldAttrs: rec {
  #   configFile = pkgs.writeText "config.h" (builtins.readFile ./modules/desktop/dwm/dwm-config.h);
  #   postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
  # });
in
{
  services = {
    xserver = {
      windowManager= {
        dwm = {                                 # Window Manager
          enable = true;
          # package = pkgs.dwm.override {
          #   patches = [
          #     (pkgs.fetchpatch {
          #       url = "https://dwm.suckless.org/patches/systray/dwm-systray-6.4.diff";
          #       sha256 = "TXErH76w403T9tSJYu3tAJrQX3Y3lKSulKH0UdQLG/g=";
          #     })
          #     (pkgs.fetchpatch {
          #       url = "https://dwm.suckless.org/patches/cool_autostart/dwm-cool-autostart-6.2.diff";
          #       sha256 = "/LYv65Z4mLjkirhiz8X47/bBI6KLZywqDSkJNyZK5UI=";
          #     })
          #     # (pkgs.fetchpatch {
          #     #   url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
          #     #   sha256 = "mrHh4o9KBZDp2ReSeKodWkCz5ahCLuE6Al3NR2r2OJg=";
          #     # })
          #     (pkgs.fetchpatch {
          #       url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
          #       sha256 = "wRZP/27V7xYOBnFAGxqeJFXdoDk4K1EQMA3bEoAXr/0=";
          #     })
          #     # (pkgs.fetchpatch {
          #     #   url = "https://dwm.suckless.org/patches/fancybar/dwm-fancybar-20220527-d3f93c7.diff";
          #     #   sha256 = "twTkfKjOMGZCQdxHK0vXEcgnEU3CWg/7lrA3EftEAXc=";
          #     # })
          #     # (pkgs.fetchpatch {
          #     #   url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff";
          #     #   sha256 = "IkVGUl0y/DvuY6vquSmqv2d//QSLMJgFUqi5YEiM8cE=";
          #     # })
          #   ];
          # };
        };
      };
    };
  };
  environment.systemPackages = with pkgs; [       # Packages installed
    dwm-git
    dwmblocks
  ];
}
