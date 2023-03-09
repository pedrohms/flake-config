{ inputs, user, pkgs, my-overlays, ... }:

{
  home = {
    packages = with pkgs; [ 
      xarchiver
      ghq
      sumneko-lua-language-server
      authenticator
      discord
      firefox
      google-chrome
    ];
  };
}
