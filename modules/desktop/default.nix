#
#  Desktop configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  programs = {
    dconf.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      libinput.enable = true; # Enable touchpad
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
        Option "AllowNVIDIAGPUScreens" "True"
      '';                                         # Used so computer does not goes to sleep

    };
    printing.enable = true;
  };
  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    sxhkd
    deckmaster
    dunst
    pywal
    clipmenu
    xorg.xev
    xorg.xkill
    xorg.xrandr
    waybar
    swaybg
    wl-clipboard
    playerctl
    libappindicator-gtk3
    imagemagick_light
    sway-contrib.grimshot
    wf-recorder
  ];

  xdg.portal = {                                  # Required for flatpak with windowmanagers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal ];
  };
}
