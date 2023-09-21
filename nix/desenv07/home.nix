{ inputs, user, pkgs, my-overlays, ... }:

{
  home = {
    packages = with pkgs; [ 
      libreoffice 
      authenticator
      parsec-bin
      azuredatastudio
      android-studio
      sumneko-lua-language-server
      gradle
      vscode
      discord
      firefox
      google-chrome
      remmina
      jdk11
      ghq
      anydesk
      rustdesk
      moonlight-qt
      distrobox
      steam
      lutris
      wineWowPackages.waylandFull
      dxvk
      winetricks
      flameshot
      wezterm
      wofi
      postman
      openssl
    ];

    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      #name = "Dracula-cursors";
      name = "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };

  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      #name = "Catppuccin-Dark";
      package = pkgs.dracula-theme;
      #package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";         # or FiraCode Nerd Font Mono Medium
    };                                        # Cursor is declared under home.pointerCursor
  };
}
