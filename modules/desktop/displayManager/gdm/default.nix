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
    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet -c ${pkgs.dwl}/bin/dwl";
    #     };
    #   };
    # };
    xserver = {
      displayManager = {
        gdm = {
          enable = true;
        };
      };
    };
  };
}
