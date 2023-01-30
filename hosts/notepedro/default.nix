{ config, pkgs, user, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
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
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    opengl.enable = true;
    pulseaudio.enable = false;
    sane = {                           # Used for scanning with Xsane
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      simple-scan
      nvidia-offload
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    fish.enable = true;
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    #tlp.enable = true;                      # TLP and auto-cpufreq for power management
    #logind.lidSwitch = "ignore";            # Laptop does not go to sleep when lid is closed
    auto-cpufreq.enable = true;
    blueman.enable = true;
#   printing = {                            # Printing and drivers for TS5300
#     enable = true;
#     drivers = [ pkgs.cnijfilter2 ];
#   };
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
          "guest ok" = "no";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
    xserver = {
      videoDrivers = [ "nvidia" ];
      libinput = {                          # Trackpad support & gestures
        touchpad = {
          tapping = true;
          scrollMethod = "twofinger";
          naturalScrolling = true;            # The correct way of scrolling
          accelProfile = "adaptive";          # Speed settings
          #accelSpeed = "-0.5";
          disableWhileTyping = true;
        };
      };
      resolutions = [
        { x = 1600; y = 920; }
        { x = 1280; y = 720; }
        { x = 1920; y = 1080; }
      ];
    };
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];


  users.users.${user} = {
    shell = pkgs.fish;
  };
}
