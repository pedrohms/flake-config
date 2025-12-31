#  Plasma configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./desktopManager
#               └─ ./plasma
#                   └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    desktopManager = {
      plasma6 = {
        enable = true;
        # useQtScaling = true;
      };
    };
  };
  environment.variables = rec {
    # DISPLAY = ":0";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # Wayland Platform Settings
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";

    # GTK Settings
    GDK_BACKEND = "wayland,x11";

    # Firefox Wayland
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";

    # Java Applications
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # SDL Applications
    SDL_VIDEODRIVER = "wayland";

    # CLUTTER Applications
    CLUTTER_BACKEND = "wayland";

    # # Performance
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "iHD";
  };
}
