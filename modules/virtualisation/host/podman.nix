{ config, pkgs, user, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        crun
        gvisor
      ];
    };
    containers.cdi.dynamic.nvidia.enable = true;
  };

  
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
