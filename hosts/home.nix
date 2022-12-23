{ config, lib, pkgs, user, ... }:

{

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
   
    stateVersion = "23.05";
    packages = with pkgs; [
      home-manager
      exa
      stow
      starship
      picom
      rofi
      rofi-calc
      tmux
      lazygit
      fzf
      conky
      lxappearance
      pcmanfm
      appimage-run
      feh
      dmenu
      bat
      ripgrep
      neovim-nightly
      scrot
    ];

    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      #name = "Dracula-cursors";
      name = "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };
  };

  programs = {
    home-manager.enable = true;
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
