{ inputs, user, pkgs, my-overlays, ... }:

{
  home = {
    packages = with pkgs; [ 
      dconf
      xarchiver
      android-studio                         # Office packages
      gradle
      # winePackages.unstable
      # wineWowPackages.stable
      # wine64
      wezterm
      wofi
      firefox
      postman
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
