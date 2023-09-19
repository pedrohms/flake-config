{ pkgs, myFlakeVersion, ... }:
{
  dwm = pkgs.callPackage ./dwm/pkg.nix { myFlakeVersion = myFlakeVersion; };
  dwmblocks = pkgs.callPackage ./dwmblocks/pkg.nix { myFlakeVersion = myFlakeVersion; };
  bun-1_0 = pkgs.callPackage ./bun/pkg.nix { myFlakeVersion = myFlakeVersion; };
  grimblast = pkgs.callPackage ./grimblast/default.nix { myFlakeVersion = myFlakeVersion; };

}
