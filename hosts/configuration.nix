# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, user, location, myFlakeVersion, ... }:

{

  boot.supportedFilesystems = [ "ntfs" ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
   LC_TIME = "pt_BR.UTF-8";
   LC_MONETARY = "pt_BR.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man.enable = true;
    nixos.enable = true;
  };
  # Enable sound.
  sound.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
    };
  };

  programs = {
    adb.enable = true;
    nm-applet.enable = true;
    ssh.enableAskPassword = false;
    gnupg.agent = {
        enable = true;
        enableSSHSupport =true;
    };
    direnv = {
      enable = true;
      package = pkgs.direnv;
      silent = true;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  services = {
    udev.packages = [
     pkgs.android-udev-rules
    ];
    gnome.gnome-keyring.enable = true;
    pcscd.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
  };

  fonts.packages = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    nerdfonts
    # (nerdfonts.override {                   # Nerdfont Icons override
    #   fonts = [
    #     "FiraCode"
    #   ];
    # })
  ]; 

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      jq
      sqlite
      wget
      git
      brave
      fish
      alacritty
      kitty
      xorg.xrandr
      lshw
      killall
      unzip
      zip
      pciutils
      usbutils
      networkmanagerapplet
      # lxappearance
      home-manager
      eza
      nh
      stow
      starship
      picom
      rofi-wayland
      rofi-calc
      tmux
      lazygit
      fzf
      conky
      pcmanfm
      feh
      dmenu
      bat
      ripgrep
      neovim-nightly
      ntfs3g
      scrot
      gnome.gnome-keyring
      acpi
      libstdcxx5
      ffmpeg_6
      pamixer
      polkit
      polkit_gnome
      bluez
      vulkan-tools
      glxinfo
      virtualglLib
      clinfo
      nvd
      nix-output-monitor
      mpv
      lxqt.lxqt-openssh-askpass
    ];
  };

  nix = {
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixVersions.git;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.
  
  system = {                                # NixOS settings
    autoUpgrade = {                         # Allow auto update (not useful in flakes)
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "24.05";
  };

  # boot.kernel.sysctl."vm.max_map_count" = 2147483642;

}
