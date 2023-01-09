{ config, pkgs, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    (import ../../modules/virtualization) ++
    [(import ../../modules/desktop/awesome/default.nix)];   # virtualization

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {                              # Most of grub is set up for dual boot
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                 # Find all boot options
        configurationLimit = 2;
      };
      timeout = 1;                          # Grub auto select time
    };
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      amdvlk
    ];
    opengl.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    pulseaudio.enable = true;
    sane = {                           # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      simple-scan
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    fish.enable = true;
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    flatpak.enable = true;
    avahi = {                               # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                           # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    samba = {
      enable = true;
      shares = {
        share = {
          "path" = "/home/${user}/Public";
          "guest ok" = "true";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
    xserver = {
      videoDrivers = [ "amdgpu" ];
      resolutions = [
        { x = 1600; y = 920; }
        { x = 1280; y = 720; }
        { x = 1920; y = 1080; }
      ];
    };
  };
  users.users.${user} = {
    shell = pkgs.fish;
  };
}
