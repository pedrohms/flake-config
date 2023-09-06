{inputs, config, pkgs, user, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
     (import ./virtualisation.nix) ++                     # virtualisation
    [(import ./desktop.nix)];                             # desktop

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

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
      };
      timeout = 4;                          # Grub auto select time
    };
  };

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };
  hardware = {
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      prime = {
        #sync.enable = true;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

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
    flatpak.enable = true;
    # tlp = {                                  # TLP and auto-cpufreq for power management
    #   enable = true;
    #   settings = {
    #     RUNTIME_PM_DRIVER_BLACKLIST = "nouveau mei_me";
    #   };
    # };
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
      layout = "br";
      xkbVariant = "abnt2";
      xkbModel = "pc105";
      videoDrivers = [ "modeset" "nvidia" ];
      dpi = 88;
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
      screenSection = ''
        Option "metamodes" "eDP-1: 1920x1080_120 +0_0, HDMI-1-0: 1920x1080_60 +1920+0"
      '';

    };
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];


  users.users.${user} = {
    uid = 1000;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" "tss"];
    initialPassword = "123456";
  };
  
  users.groups.${user} = {
    gid = 1000;
    members = [ "${user}" ];
  };
}
