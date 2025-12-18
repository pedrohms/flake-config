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
    displayManager = {
      gdm = {
        enable = true;
      };
    };
  };
  environment.systemPackages = with pkgs; [       # Packages installed
    gnome.file-roller
    gnome.nautilus
    gnome.gnome-autoar
    gnome.sushi
  ];
}
