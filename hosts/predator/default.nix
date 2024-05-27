{inputs, config, pkgs, user, myFlakeVersion, lib, ... }:
let
  localPkgs = import ../../modules/packages { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };
in 
{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
     (import ./virtualisation.nix) ++                     # virtualisation
     (import ./desktop.nix)                              # desktop
  ;

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # loader = {                              # EFI Boot
    #   efi = {
    #     canTouchEfiVariables = true;
    #     efiSysMountPoint = "/boot";
    #   };
    #   grub = {                              # Most of grub is set up for dual boot
    #     enable = true;
    #     devices = [ "nodev" ];
    #     efiSupport = true;
    #     useOSProber = true;                 # Find all boot options
    #   };
    #   timeout = 10;                          # Grub auto select time
    # };
  };

  specialisation = {
    hybrid.configuration = {
      environment = {
        variables = rec {
          LIBGL_DRI3_DISABLE        = "true";
          PH_MACHINE                = "predator";
          PH_NVIDIA                 = "2";
          # KWIN_DRM_DEVICES          = "/dev/dri/card0:/dev/dri/card1";
          # WLR_DRM_DEVICES           = "/dev/dri/card0:/dev/dri/card1";
        };
      };
      hardware = {
        nvidia = {
          # open = true;
          package = config.boot.kernelPackages.nvidiaPackages.production;
          prime = {
            sync.enable = lib.mkForce false;
            # reverseSync.enable = true;
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
          };
        };
      };
    };
  };

  security = {
    tpm2 = {
      enable = false;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  # powerManagement = {
  #   enable = true;
  #   cpuFreqGovernor = "performance";
  # };

  services.power-profiles-daemon.enable = true;

# services.tlp = {                                  # TLP and auto-cpufreq for power management
#   enable = true;
#   settings = {
#     CPU_BOOST_ON_AC = 1;
#     CPU_BOOST_ON_BAT = 0;

#     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
#     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

#     CPU_SCALING_GOVERNOR_ON_AC = "performance";
#     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

#     # TLP_DEFAULT_MODE = "BAT";
#     # TLP_PERSISTENT_DEFAULT = 1;

#     # RUNTIME_PM_ON_AC = "on";
#     USB_AUTOSUSPEND = 0;

#     RUNTIME_PM_ON_BAT = "auto";
#     RUNTIME_PM_DRIVER_BLACKLIST = "mei_me nouveau nvidia"; 
#   };
# };

  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      prime = {
        sync.enable = true;
        # reverseSync.enable = true;
        offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
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
    steam-hardware.enable = true;
  };

  environment = {
    sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    variables = rec {
      LIBGL_DRI3_DISABLE        = "true";
      PH_MACHINE                = "predator";
      FLAKE                     = "/home/pedro/.setup";
      KWIN_DRM_DEVICES          = "/dev/dri/card1:/dev/dri/card2";
      # QT_AUTO_SCREEN_SET_FACTOR = 0;
      # QT_SCALE_FACTOR           = 1.1;
      # QT_FONT_DPI               = 96;
      # GDK_SCALE                 = 1.1;
      # GDK_DPI_SCALE             = 0.5;
      # KWIN_DRM_DEVICES          = "/dev/dri/card0:/dev/dri/card1";
      # WLR_DRM_DEVICES           = "/dev/dri/card0:/dev/dri/card1";
      # PH_NVIDIA                 = "0";
      FLAKE = "/home/pedro/.setup";
    };
    systemPackages = with pkgs; [
      simple-scan
      powertop
    ] ++ [  ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    fish.enable = true;
    dconf.enable = true;
    light.enable = true;
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gamescope = {
      enable = true;
      # env = {
      #   __NV_PRIME_RENDER_OFFLOAD = "1";
      #   __VK_LAYER_NV_optimus = "NVIDIA_only";
      #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # };
    };
  };

  services = {
    flatpak.enable = true;
    thermald.enable = true;
    #logind.lidSwitch = "ignore";            # Laptop does not go to sleep when lid is closed
    # auto-cpufreq.enable = true;
    # blueman.enable = true;
#   printing = {                            # Printing and drivers for TS5300
#     enable = true;
#     drivers = [ pkgs.cnijfilter2 ];
#   };
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
          path = "/home/${user}/Public";
          public = "yes";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "pedro";
          "force group" = "pedro";
        };
      };
      extraConfig = ''
        guest account = pedro
      '';
      openFirewall = true;
    };
    xserver = {
      xkb = {
        layout = "br";
        variant = "abnt2";
        model = "pc105";
      };
      videoDrivers = [ "nvidia" ];
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
      displayManager.sessionCommands = ''
       ${pkgs.xorg.xrandr}/bin/xrandr --auto
      '';
      screenSection = ''
        Option "metamodes" "eDP-1: 1920x1080_120 +0_0, HDMI-1-0: 1920x1080_60 +1920+0"
      '';
      displayManager = {
        gdm = {
          wayland = true;
        };
      };
    };
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
    "d /var/spool/samba 1777 root root -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];

  users = {
    users.${user} = {
      uid = 1000;
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" "tss"];
      initialPassword = "123456";
      subUidRanges = [
        { count = 65535; startUid = 100000; }
      ];
      subGidRanges = [
        { count = 65535; startGid = 100000; }
      ];
    };
    # extraUsers.${user} = {
    # };
  };
  users.groups.${user} = {
    gid = 1000;
    members = [ "${user}" ];
  };

  systemd.enableUnifiedCgroupHierarchy = lib.mkForce true;
}
