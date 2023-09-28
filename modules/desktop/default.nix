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
      # displayManager.sessionCommands = ''
      #  ${pkgs.xorg.xrandr}/bin/xrandr --auto
      # '';
      # ${pkgs.xorg.xrandr}/bin/xrandr --mode 1920x1080 --pos 0x0 --rotate normal
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
    wlr-randr
    playerctl
    libappindicator-gtk3
    imagemagick_light
    sway-contrib.grimshot
    wf-recorder
    xdg-desktop-portal-hyprland
    swappy
    libsForQt5.polkit-kde-agent
    kanshi
  ];

  xdg.portal = {                                  # Required for flatpak with windowmanagers
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
