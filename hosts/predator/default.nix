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
    kernelPackages = pkgs.linuxPackages_zen;
    # loader.systemd-boot.enable = true;
    # loader.efi.canTouchEfiVariables = true;
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
      timeout = 10;                          # Grub auto select time
    };
  };


  # specialisation = {
  #   hybrid.configuration = {
  #     environment = {
  #       variables = rec {
  #         LIBGL_DRI3_DISABLE        = "true";
  #         PH_MACHINE                = "predator";
  #         PH_NVIDIA                 = "2";
  #         # KWIN_DRM_DEVICES          = "/dev/dri/card0:/dev/dri/card1";
  #         # WLR_DRM_DEVICES           = "/dev/dri/card0:/dev/dri/card1";
  #       };
  #     };
  #     hardware = {
  #       nvidia = {
  #         open = true;
  #         package = config.boot.kernelPackages.nvidiaPackages.latest;
  #         prime = {
  #           sync.enable = lib.mkForce false;
  #           # reverseSync.enable = true;
  #           offload = {
  #             enable = true;
  #             enableOffloadCmd = true;
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

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

services.power-profiles-daemon.enable = false;

services.tlp = {
    enable = true;
    settings = {
      # --- GERAL ---
      "TLP_ENABLE" = 1;
      "TLP_DEFAULT_MODE" = "BAT";
      "TLP_PERSISTENT_DEFAULT" = 0;

      # --- PROCESSADOR (CPU) ---
      # Define o governador de escalonamento.
      # 'performance' mantém o clock alto (bom para jogos).
      # 'powersave' permite que a CPU reduza a frequência agressivamente.
      "CPU_SCALING_GOVERNOR_ON_AC" = "performance";
      "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";

      # Define a preferência de energia (EPP) para processadores modernos (Intel Core i / AMD Ryzen).
      # 'balance_performance': Permite turbo boost e alta resposta, mas economiza quando ocioso.
      # 'power': Foca puramente em economia.
      "CPU_ENERGY_PERF_POLICY_ON_AC" = "balance_performance";
      "CPU_ENERGY_PERF_POLICY_ON_BAT" = "power";

      # Controle do Turbo Boost.
      # Desativar o boost na bateria reduz drasticamente o calor e consumo.
      "CPU_BOOST_ON_AC" = 1;
      "CPU_BOOST_ON_BAT" = 0;

      # Define limites de frequência (Opcional, mas útil para economizar bateria).
      # Deixar em branco usa os padrões do hardware.
      # "CPU_MAX_PERF_ON_AC" = 100;
      # "CPU_MAX_PERF_ON_BAT" = 50; # Limita a CPU a 50% na bateria

      # --- PLATFORM PROFILE (Se suportado pelo hardware) ---
      # Controla perfis térmicos e de energia do sistema (ACPI).
      "PLATFORM_PROFILE_ON_AC" = "performance";
      "PLATFORM_PROFILE_ON_BAT" = "low-power";

      # --- PLACA DE VÍDEO (GPU) ---
      # Otimização do barramento PCIe (ASPM).
      # 'default': Usa o padrão da BIOS (geralmente performance).
      # 'powersupersave': Máxima economia no barramento.
      "PCIE_ASPM_ON_AC" = "default";
      "PCIE_ASPM_ON_BAT" = "powersupersave";

      # Para GPUs AMD (Radeon)
      # "RADEON_DPM_STATE_ON_AC" = "performance";
      # "RADEON_DPM_STATE_ON_BAT" = "battery";
      # "RADEON_POWER_PROFILE_ON_AC" = "default";
      # "RADEON_POWER_PROFILE_ON_BAT" = "low";

      # --- DISCOS / ARMAZENAMENTO ---
      # Define o tempo para suspender discos rotativos (se houver) e link power management para SSDs/SATA.
      "AHCI_RUNTIME_PM_ON_AC" = "on";
      "AHCI_RUNTIME_PM_ON_BAT" = "auto";

      # --- REDE / CONECTIVIDADE ---
      # Desliga o Wifi/Bluetooth automaticamente se o cabo LAN for conectado (Opcional).
      "WIFI_PWR_ON_AC" = "off";
      "WIFI_PWR_ON_BAT" = "on";

      # --- CUIDADO COM A BATERIA (THRESHOLDS) ---
      # Aumenta a vida útil da bateria evitando cargas de 100% constantes.
      # NOTA: Isso depende da marca do notebook (ThinkPad, ASUS, etc).
      # Se o seu notebook suportar, descomente as linhas abaixo.
      
      # Exemplo: Começa a carregar se baixar de 75% e para em 80%.
      "START_CHARGE_THRESH_BAT1" = 75;
      "STOP_CHARGE_THRESH_BAT1" = 80;
    };
  };

  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        sync.enable = false;
        # reverseSync.enable = true;
        offload = {
          enable = lib.mkForce true;
          enableOffloadCmd = lib.mkForce true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
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
      CHROMIUM_USER_FLAGS       = "$HOME/.config/chromium-flags.conf";
      # QT_AUTO_SCREEN_SET_FACTOR = 0;
      # QT_SCALE_FACTOR           = 1.1;
      # QT_FONT_DPI               = 96;
      # GDK_SCALE                 = 1.1;
      # GDK_DPI_SCALE             = 0.5;
      # KWIN_DRM_DEVICES          = "/dev/dri/card0:/dev/dri/card1";
      # WLR_DRM_DEVICES           = "/dev/dri/card0:/dev/dri/card1";
      # PH_NVIDIA                 = "2";
    };
    systemPackages = with pkgs; [
      simple-scan
      powertop
      ifuse
      ipad_charge
      libimobiledevice
      lm_sensors
    ] ++ [  ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    fish.enable = true;
    dconf.enable = true;
    light.enable = true;
    gamemode.enable = true;
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gamescope = {
      enable = true;
      env = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
  };

  services = {
    flatpak.enable = true;
    thermald.enable = true;
    pulseaudio.enable = false;
    logind.lidSwitch = "hibernate";            # Laptop does not go to sleep when lid is closed
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
      settings = {
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
      # extraConfig = ''
      #   guest account = pedro
      # '';
      openFirewall = true;
    };
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
    xserver = {
      xkb = {
        layout = "us";
        variant = "intl";
        model = "pc105";
      };
      videoDrivers = [ "nvidia" ];
      dpi = 88;
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
    };
    displayManager = {
      gdm = {
        wayland = true;
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
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" "tss" "usbmux"];
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
  # systemd.enableUnifiedCgroupHierarchy = lib.mkForce true;
}
