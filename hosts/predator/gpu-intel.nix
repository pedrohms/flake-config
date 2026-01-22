{
  services.xserver.videoDrivers = [ "modesetting" ];

  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];
}
