
{ config, pkgs, user, ... }:

{
  virtualisation = {
    vmware = {
      guest = {
        enable = true;
      };
    };
  };
}
