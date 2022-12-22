{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
    };
  };


  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
