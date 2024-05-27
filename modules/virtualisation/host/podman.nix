{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      enableNvidia = true;
    };
  };


  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
