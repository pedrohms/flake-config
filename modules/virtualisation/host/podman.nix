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
  };
  
  hardware.nvidia-container-toolkit.enable = true;
  
  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
