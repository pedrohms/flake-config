{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };


  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
