{ inputs, user, pkgs, my-overlays, ... }:
let
  android-wayland = pkgs.runCommand "android-studio-wayland" { buildInputs = [ pkgs.makeWrapper ]; } ''
      makeWrapper ${pkgs.android-studio}/bin/android-studio $out/bin/android-studio-wayland --set QT_QPA_PLATFORM xcb
  '';
  # microsoft-edge = pkgs.symlinkJoin {
  #       name = "microsoft-edge";
  #       paths = [ pkgs.microsoft-edge ];
  #       buildInputs = [ pkgs.makeWrapper ];
  #       postBuild = ''
  #         wrapProgram $out/bin/microsoft-edge --add-flags '--enable-features=UseOzonePlatform --ozone-platform=wayland --ozone-platform-hint=wayland --gtk-version=4 --ignore-gpu-blocklist'
  #       '';
  #     };
in {
  home = {
    packages = with pkgs; [ 
      dconf
      xarchiver
      # android-wayland                         # Office packages
      # android-studio
      # flutter
      # gradle
      # winePackages.unstable
      wineWowPackages.stable
      # wine64
      wezterm
      wofi
      firefox
      brave
      postman
      appimage-run
      lutris
      podman-desktop
      vlc
      microsoft-edge
      obs-studio

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
