{ inputs, user, pkgs, my-overlays, ... }:

{

  home = {
    packages = with pkgs; [ 
      android-studio
      gradle
      jetbrains.idea-community
      parsec-bin
      # jdk21
      # wezterm
      # wofi
      # foot
      # bottles
      # hexchat
      neovide
      anydesk
      podman-desktop
      postman
      steam
      microsoft-edge-beta
      moonlight-qt
      dbeaver
      imagemagick
      transmission-gtk
      sqlcmd
      minecraft
      appimage-run
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
