#  Sway configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./sway
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:
let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = [
        "--unsupported-gpu"
      ];
      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=sway 
        export XDG_SESSION_TYPE=wayland 
        export XDG_SESSION_DESKTOP=sway 
        export GDK_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=qt5ct 
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export SDL_VIDEODRIVER=wayland 
        export _JAVA_AWT_WM_NONREPARENTING=1
        export WLR_NO_HARDWARE_CURSORS=1 
        export MOZ_DISABLE_RDD_SANDBOX=1
        export MOZ_ENABLE_WAYLAND=1 
        export OZONE_PLATFORM=wayland
        export LIBVA_DRIVER_NAME=nvidia
        export XDG_SESSION_TYPE=wayland
        export GBM_BACKEND=nvidia
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __VK_LAYER_NV_optimus=NVIDIA_only
      '';
    };
  };
  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    configure-gtk
    dbus-sway-environment
    libappindicator
  ];
}
