{ inputs, user, pkgs, my-overlays, ... }:

{
  home.packages = [ 
    pkgs.htop
  ];
}
