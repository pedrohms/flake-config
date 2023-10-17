{ inputs, user, pkgs, my-overlays, ... }:

{
  home = {
    packages = with pkgs; [ 
      dconf
      xarchiver
      android-studio                         # Office packages
      azuredatastudio
      gradle
      # winePackages.unstable
      # wineWowPackages.stable
      # wine64
      wezterm
      wofi
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
