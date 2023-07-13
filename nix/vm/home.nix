{ inputs, user, pkgs, my-overlays, ... }:

{
  home = {
    packages = with pkgs; [ 
      xarchiver
      ghq
      sumneko-lua-language-server
      jq
      gradle
    ];
  };

}
