# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "amdgpu" ];
  # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];

  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

#  fileSystems."/mnt/dados" =
#    { device = "/dev/sdb5";
#      options = [ "rw" "users" "defaults" ];
#      fsType = "ntfs3";
#    };

  swapDevices = [ {
      device = "/var/lib/swapfile"; 
      size = 16*1024;
    } ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "desenv07-nix";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [
        1433
      ];
    };
  };
  # networking.interfaces.enp0s20f0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
