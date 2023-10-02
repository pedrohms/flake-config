{ config, pkgs, user, myFlakeVersion, ... }:
let
  localPkgs = import ../../modules/packages { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };
in 
{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
     (import ./virtualisation.nix) ++                     # virtualisation
     (import ./desktop.nix)
  ;

  boot = {                                  # Boot options
    kernelPackages =  pkgs.linuxPackages_latest;

    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {                              # Most of grub is set up for dual boot
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;                 # Find all boot options
        configurationLimit = 2;
      };
      timeout = 1;                          # Grub auto select time
    };
    kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = "1";
      "net.ipv6.conf.all.proxy_ndp" = "1";
      "net.ipv4.conf.all.forwarding" = "1";
      "net.ipv4.conf.all.proxy_ndp" = "1";
    };
  };

  hardware = {
    openrazer = {
        enable = false;
        users = [ "framework" ];
    };
    opengl.extraPackages = with pkgs; [
      amdvlk
    ];
    opengl.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    pulseaudio.enable = false;
    sane = {                           # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      simple-scan
      # linuxKernel.packages.linux_latest_libre.openrazer
      # openrazer-daemon
      polychromatic
    ] ++ [  ];
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
          "path" = "/home/framework/Public";
          "guest ok" = "true";
          "read only" = "no";
        };
      };
      extraConfig =''
        force user = framework
        force group = framework
      '';
      openFirewall = true;
    };
    xserver = {
      layout = "us";
      xkbVariant = "intl";
      xkbModel = "pc105";
      videoDrivers = [ "amdgpu" ];
      resolutions = [
        { x = 1600; y = 920; }
        { x = 1280; y = 720; }
        { x = 1920; y = 1080; }
      ];
    };
  };
  users.users.framework = {
    uid = 1000;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" "openrazer" ];
    initialPassword = "123456";
  };

  users.groups.framework = {
    gid = 1000;
    members = [ "framework" ];
  };
}
