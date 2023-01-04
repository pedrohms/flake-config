#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#              └─ hyprland.nix
#

{ pkgs, ... }:

{
# imports =
#   [
#     ../../modules/desktop/bspwm/home.nix # Window Manager
#   ];

  home = {                                # Specific packages for laptop
    packages = with pkgs; [
      # Applications
      libreoffice                         # Office packages
      android-studio
      gradle
      azuredatastudio
      vscode
      zip
      anydesk
      # Display
      #light                              # xorg.xbacklight not supported. Other option is just use xrandr.

      # Power Management
      #auto-cpufreq                       # Power management
      #tlp                                # Power management
    ];
  };

# programs = {
#   alacritty.settings.font.size = 11;
# };

  services = {                            # Applets
    network-manager-applet.enable = true; # Network
  };
}
