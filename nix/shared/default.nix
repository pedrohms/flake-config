{ inputs, user, pkgs, my-overlays, ... }:

{

  home = {
    packages = with pkgs; [ 
      libreoffice 
      authenticator
      parsec-bin
      sumneko-lua-language-server
      vscode
      discord
      firefox
      google-chrome
      remmina
      ghq
      jq
      anydesk
      distrobox
      steam
      wineWowPackages.waylandFull
      dxvk
      winetricks
      flameshot
      openssl
      clang-tools_16
      lolcat
      gnome.file-roller
      gnome.nautilus
      gnome.gnome-autoar
      gnome.sushi
      gnome.gnome-boxes
    ];

    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      #name = "Dracula-cursors";
      name = "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };

  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
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
