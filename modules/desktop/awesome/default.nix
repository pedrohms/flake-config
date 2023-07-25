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

{ inputs, config, lib, pkgs, ... }:

{

  programs = {
    dconf.enable = true;
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      nvidiaPatches = true;
    };
  };

  services = {
    # flatpak.enable = true;
    xserver = {
      # videoDrivers = [ "nvidia" ];
      enable = true;
      layout = "br";
      xkbVariant = "abnt2";
      xkbModel = "pc105";
      libinput.enable = true; # Enable touchpad
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        defaultSession = "gnome";
      };
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
      windowManager.qtile.enable = true;
      # windowManager.qtile.backend = "wayland";
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

  # xdg.portal = {                                  # Required for flatpak with windowmanagers
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal ];
  # };
}
