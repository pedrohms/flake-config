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
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams =  [ "acpi_rev_override" "mem_sleep_default=deep" "intel_iommu=igfx_off" "nvidia-drm.modeset=1" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 config.boot.kernelPackages.acpi_call ];
  boot.postBootCommands = ''
    ${pkgs.kmod}/bin/modeprobe -i acpi_call
  ''; 

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/store";
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

  fileSystems."/mnt/backup" =
    { device = "/dev/disk/by-label/backup";
      fsType = "btrfs";
      options = [ "rw" "user" ];
    };

  swapDevices = [ {
      device = "/var/lib/swapfile"; 
      size = 16*1024;
    } ];

  networking = {
    hostName = "notepedro-g15";
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
