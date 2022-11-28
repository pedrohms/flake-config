#
#  Awesome configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./awesome
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    # flatpak.enable = true;
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      layout = "br";
      xkbVariant = "abnt2";
      xkbModel = "pc105";
      libinput.enable = true; # Enable touchpad
      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
          greeters = {
            gtk = {
              theme = {
                name = "Dracula";
                package = pkgs.dracula-theme;
              };
              cursorTheme = {
                name = "Dracula-cursors";
                package = pkgs.dracula-theme;
                size = 16;
              };
            };
          };
        };
        defaultSession = "none+awesome";
      };
      windowManager.awesome.enable = true;
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';                                         # Used so computer does not goes to sleep
      # displayManager.sessionCommands = ''
      #   ${pkgs.xorg.xrandr}/bin/xrandr --mode 1920x1080 --pos 0x0 --rotate normal
      # '';
    };
    printing.enable = true;
  };

  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    xorg.xev
    xorg.xkill
    xorg.xrandr
  ];

  xdg.portal = {                                  # Required for flatpak with windowmanagers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
