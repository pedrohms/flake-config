{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    lxd.enable = true;
  };


  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
