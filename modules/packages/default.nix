{ pkgs, myFlakeVersion }:
{
  dwm = pkgs.callPackage ./dwm/pkg.nix { myFlakeVersion = myFlakeVersion; };
}
