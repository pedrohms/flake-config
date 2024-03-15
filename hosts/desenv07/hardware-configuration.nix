# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "amdgpu" ];
  # boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];

  boot.extraModulePackages = [ ];

  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_nsrs=1
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/eb5b50f5-e626-4864-8373-b171601c5f64";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8DEA-DC4B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/caa02e86-32fe-4de3-8894-3c73114e438f"; }
    ];

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "desenv07-nix";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedUDPPorts = [
        25565
        19132
      ];
      allowedTCPPorts = [
        1433
        3000
        16000
        8080
        8000
        8090
        3306
        25565
        19132
        3389
      ];
    };
  };
  # networking.interfaces.enp0s20f0u2u4.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
