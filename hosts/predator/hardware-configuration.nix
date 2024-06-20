# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # boot.kernelModules = [ "kvm-intel" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  # boot.kernelParams =  [ "acpi_rev_override" "mem_sleep_default=deep" "intel_iommu=on" "iommu=pt" "nvidia-drm.modeset=1" ];
  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "intel_agp"
      "i915"
      "acpi_call"
  ];
  boot.blacklistedKernelModules =  [ "nouveau" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams =  [ "i915.enable_psr=0" "acpi_rev_override" "mem_sleep_default=deep" "intel_iommu=igfx_off"
                          "nvidia-drm.modeset=1" "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 config.boot.kernelPackages.acpi_call ];
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_nsrs=1
    options nvidia-drm modeset=1
    options nvidia "NVreg_DynamicPowerManagement=0x02"
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="187c", ATTRS{idProduct}=="0550", MODE="0660", GROUP="plugdev", SYMLINK+="awelc"
  '';  

  boot.postBootCommands = ''
    ${pkgs.kmod}/bin/modeprobe -i acpi_call
  ''; 
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/home";
      fsType = "btrfs";
    };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  networking = {
    hostName = "notepedro-predator";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    # interfaces = {
    #   enp0s20f0u2u4 = {
    #     useDHCP = true;
    #   };
    #   wlp2s0 = {
    #     useDHCP = true;
    #   };
    # };
    firewall = {
      enable = true;
      #allowedUDPPorts = [ 53 67 ];
      #allowedTCPPorts = [ 53 80 443 9443 ];
    };
  };

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
