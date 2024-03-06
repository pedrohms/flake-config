{inputs, config, pkgs, user, myFlakeVersion,... }:
let
  localPkgs = import ../../modules/packages { pkgs = pkgs; myFlakeVersion = myFlakeVersion; };
in 
{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    (import ./virtualisation.nix) ++                      # virtualisation
    (import ./desktop.nix);

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
        configurationLimit = 2;
      };
      timeout = 4;                          # Grub auto select time
    };
  };

  hardware = {
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      prime = {
        sync.enable = true;
        # offload = { 
        #   enable = true;
        #   enableOffloadCmd = true;
        # };
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
    ] ++ [  ];
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
        share = {
          "path" = "/home/${user}/Public";
          "guest ok" = "no";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
    xserver = {
      xkb = {
        layout = "br";
        variant = "abnt2";
        model = "pc105";
      };
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

    };
  };

  #temporary bluetooth fix
  systemd.tmpfiles.rules = [
    "d /var/lib/bluetooth 700 root root - -"
  ];
  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];


  users.users.${user} = {
    uid = 1001;
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" ];
    initialPassword = "123456";
  };

  users.users.priscila = {
    uid = 1002;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" ];
    initialPassword = "123456";
  };

  users.users.sofia = {
    uid = 1003;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" ];
    initialPassword = "123456";
  };

  users.users.arthur = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" ];
    initialPassword = "123456";
  };

  users.groups.${user} = {
    gid = 1001;
    members = [ "${user}" ];
  };

  users.groups.priscila = {
    gid = 1002;
    members = [ "priscila" ];
  };

  users.groups.sofia = {
    gid = 1003;
    members = [ "sofia" ];
  };

  users.groups.arthur = {
    gid = 1000;
    members = [ "arthur" ];
  };

}
# config = pkgs.lib.mkOverride 0 ''
# Section "ServerLayout"
#   Identifier "Layout0"
#   Screen  0  "Screen0"
#   Inactive   "Device0"
#   Option     "AllowNVIDIAGPUScreens"
# EndSection
#
# Section "Module"
#     Load           "modesetting"
# EndSection
#
# Section "Monitor"
#   Identifier "Monitor0"
#   VendorName "Unknown"
#   ModelName "Unknown"
#   Option "DPMS"
# EndSection
#
# Section "Device"
#     Identifier     "Device0"
#     Driver         "nvidia"
#     BusID          "1:0:0"
#     VendorName     "NVIDIA Corporation"
# EndSection
#
# Section "Device"
#   Identifier "intel"
#   Driver "modesetting"
# EndSection
#
# Section "Screen"
#   Identifier "Screen0"
#   Device "intel"
#   Monitor "Monitor0"
#   DefaultDepth 24
#   Option  "AllowEmptyInitialConfiguration" "True"
#   SubSection  "Display"
#     Depth 24
#   EndSubSection
# EndSection
# '';
