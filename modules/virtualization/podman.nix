{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    waydroid.enable = true;
    lxd.enable = true;
  };


  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
