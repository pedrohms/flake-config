{ config, pkgs, lib, ... }:

{

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
  ];

  boot.kernelParams =  [ "nvidia-drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  boot.extraModprobeConfig = ''
    options nvidia-drm modeset=1
    options nvidia "NVreg_DynamicPowerManagement=0x02"
  '';

  hardware.nvidia = {
    open = true;

    modesetting.enable = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;

    prime = {
      sync.enable = false;

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
