#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ home.nix
#

{ config, lib, pkgs, user, ... }:

{

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
   
    stateVersion = "26.05";
    packages = with pkgs; [
      home-manager
      eza
      stow
      starship
      lazygit
      fzf
      feh
      bat
      ripgrep
      neovim-nightly
      sumneko-lua-language-server
    ];

  };
  programs = {
    home-manager.enable = true;
  };
}
