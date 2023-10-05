{ inputs, user, pkgs, my-overlays, ... }:

{

  home = {
    packages = with pkgs; [
      lolcat
    ];
  };

}
