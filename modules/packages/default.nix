{ pkgs, myFlakeVersion }:
{
  dwm = pkgs.callPackage ./dwm/pkg.nix { myFlakeVersion = myFlakeVersion; };
  dwmblocks = pkgs.callPackage ./dwmblocks/pkg.nix { myFlakeVersion = myFlakeVersion; };
}
