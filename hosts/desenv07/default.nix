{ config, pkgs, user, myFlakeVersion, lib, pkgs-staging-next, ... }:
# let
#   localPkgs = import ../../modules/packages { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };
# in 
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

  powerManagement.cpuFreqGovernor = "performance";
  hardware = {
    # openrazer = {
    #     enable = false;
    #     users = [ "framework" ];
    # };
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
     # waydroid
     simple-scan
      # linuxKernel.packages.linux_latest_libre.openrazer
      # openrazer-daemon
      # polychromatic
    ];
    sessionVariables = {
      FLAKE = "/home/framework/.setup";
    };
  };

  programs = {                              # No xbacklight, this is the alterantive
    # zsh.enable = true;
    fish.enable = true;
    dconf.enable = true;
  };

  # services.openssh.enable = lib.mkForce false;

  system.replaceRuntimeDependencies = [
    {
      original = pkgs.xz;
      replacement = pkgs-staging-next.xz;
    }
  ];

  services = {
    # zerotierone = {
    #   enable = false;
    #   joinNetworks = [ "8bd5124fd6092278"];
    # };
    # mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    # };
    power-profiles-daemon.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        X11Forwarding = true;
      };
    };
    flatpak.enable = true;
    avahi = {                               # Needed to find wireless printer
      enable = true;
      nssmdns4 = true;
      publish = {                           # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    samba = {
      enable = true;
      shares = {
        public = {
          path = "/home/framework/Public";
          public = "yes";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "framework";
          "force group" = "framework";
        };
      };
      extraConfig = ''
        guest account = framework
      '';
      openFirewall = true;
    };
    xserver = {
      # desktopManager.xfce.enable = true;
      xkb = {
        layout = "br";
        variant = "abnt2";
        model = "pc105";
      };
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
    # shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" "openrazer" "usbmux"];
    initialPassword = "123456";
  };

  users.groups.framework = {
    gid = 1000;
    members = [ "framework" ];
  };
  # virtualisation.waydroid.enable = true;
  systemd.enableUnifiedCgroupHierarchy = lib.mkForce true;
  systemd.user.services.xdg-desktop-portal-gtk = {
    wantedBy = [ "xdg-desktop-portal.service" ];
    before = [ "xdg-desktop-portal.service" ];
  };
}
