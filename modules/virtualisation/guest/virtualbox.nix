
{ config, pkgs, user, ... }:

{
  virtualisation = {
    virtualbox = {
      guest = {
        enable = true;
      };
    };
  };
}
