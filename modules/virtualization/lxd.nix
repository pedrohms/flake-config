{ config, pkgs, user, ... }:

{
  virtualisation = {
    lxd = {
      enable = true;
    };
  };
}
