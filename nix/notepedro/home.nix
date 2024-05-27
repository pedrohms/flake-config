{ inputs, user, pkgs, my-overlays, ... }:
let
  android-wayland = pkgs.runCommand "android-studio-wayland" { buildInputs = [ pkgs.makeWrapper ]; } ''
      makeWrapper ${pkgs.android-studio}/bin/android-studio $out/bin/android-studio-wayland --set QT_QPA_PLATFORM xcb
  '';
in {
  home = {
    packages = with pkgs; [ 
      dconf
      xarchiver
      android-wayland                         # Office packages
      android-studio
      gradle
      # winePackages.unstable
      wineWowPackages.stable
      # wine64
      wezterm
      wofi
      firefox
      postman
      appimage-run
      lutris
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
