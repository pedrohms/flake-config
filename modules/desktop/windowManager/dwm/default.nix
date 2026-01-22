#
#  Dwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./windowManager
#               └─ ./dwm
#                   └─ default.nix *
#

{ config, lib, pkgs, myFlakeVersion, ... }:
let
  localPkgs = import ../../../packages/default.nix { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };

  dwmWrapped = pkgs.writeShellScriptBin "dwm" ''
    unset WAYLAND_DISPLAY
    eval $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets)
    export SSH_AUTH_SOCK

    exec ${localPkgs.dwm}/bin/dwm "$@"
  '';

  customPackages = with localPkgs; [
    dwmWrapped 
    localPkgs.dwmblocks
  ];
in 
{
  services = {
    xserver = {
      windowManager = {
        dwm = {                                 # Window Manager
          enable = true;
          package = dwmWrapped;
        };
      };
    };
  };

  environment.systemPackages = customPackages;
}
