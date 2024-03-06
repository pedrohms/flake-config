{ inputs, user, pkgs, my-overlays, ... }:

{

  # imports = [ ../../modules/desktop/windowManager/dwl/default.nix ];

  # programs = {
    # dwl = {
    #   enable = true;
    #   # patches = [
    #     # ./dwl-patches/focusdirection.patch
    #     # ./dwl-patches/attachbottom.patch
    #     # ./dwl-patches/monfig.patch
    #     # ./dwl-patches/point.patch
    #     # ./dwl-patches/restoreTiling.patch
    #     # ./dwl-patches/toggleKbLayout.patch
    #     # ./dwl-patches/cursor_warp.patch
    #     # ./dwl-patches/output-power-management.patch
    #     # ./dwl-patches/autostart.patch
    #     # ./dwl-patches/vanitygaps.patch
    #   # ];
    #   cmd = {
    #     # fuzzel_timer = "${fuzzel_timer_helper}/bin/fuzzel_timer_helper";
    #     terminal = "${pkgs.foot}/bin/foot";
    #   };
    # };
    # i3status.enable = true;
  # };

  home = {
    packages = with pkgs; [ 
      android-studio
      gradle
      jetbrains.idea-community
      # jdk21
      # wezterm
      # wofi
      # foot
      # bottles
      # hexchat
      podman-desktop
      postman
    ];

    # sessionVariables = {
    #   JAVA_HOME = "${pkgs.jdk17}";
    # };

  };

  # systemd.user.sessionVariables = {
  #     JAVA_HOME = "${pkgs.jdk17}";
  # };

  # services.kanshi = {
  #   enable = true;
  #
  #   profiles = {
  #     office = {
  #       outputs = [
  #         {
  #           criteria = "HDMI-A-0";
  #           position = "0,0";
  #           mode = "1920x1080@60Hz";
  #         }
  #         {
  #           criteria = "DVI-D-0";
  #           position = "1920,0";
  #           mode = "1920x1080@60Hz";
  #         }
  #       ];
  #     };
  #   };
  # };
  #
  # wayland = {
  #   windowManager = {
  #     sway = {
  #       config = {
  #         terminal = "wezterm";
  #         startup = [ 
  #           { command = "waybar"; }
  #           { command = "wezterm start tmux"; }
  #         ];
  #       };
  #     };
  #   };
  # };
  #
  # xsession.windowManager.i3.enable = true;
}
