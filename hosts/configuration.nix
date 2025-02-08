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

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
        vulkan-tools
        mesa.drivers
      ];
    };
    pulseaudio.enable = false;
    alsa.enable = false;
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
    usbmuxd = {
      enable = true;
    };
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
    # nerd-fonts.0xproto
    nerd-fonts._3270
    nerd-fonts.agave
    nerd-fonts.anonymice
    nerd-fonts.arimo
    nerd-fonts.aurulent-sans-mono
    nerd-fonts.bigblue-terminal
    nerd-fonts.bitstream-vera-sans-mono
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.code-new-roman
    nerd-fonts.comic-shanns-mono
    nerd-fonts.commit-mono
    nerd-fonts.cousine
    nerd-fonts.d2coding
    nerd-fonts.daddy-time-mono
    nerd-fonts.departure-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.envy-code-r
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.geist-mono
    nerd-fonts.go-mono
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.heavy-data
    nerd-fonts.hurmit
    nerd-fonts.im-writing
    nerd-fonts.inconsolata
    nerd-fonts.inconsolata-go
    nerd-fonts.inconsolata-lgc
    nerd-fonts.intone-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.jetbrains-mono
    nerd-fonts.lekton
    nerd-fonts.liberation
    nerd-fonts.lilex
    nerd-fonts.martian-mono
    nerd-fonts.meslo-lg
    nerd-fonts.monaspace
    nerd-fonts.monofur
    nerd-fonts.monoid
    nerd-fonts.mononoki
    nerd-fonts.mplus
    nerd-fonts.noto
    nerd-fonts.open-dyslexic
    nerd-fonts.overpass
    nerd-fonts.profont
    nerd-fonts.proggy-clean-tt
    nerd-fonts.recursive-mono
    nerd-fonts.roboto-mono
    nerd-fonts.shure-tech-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.space-mono
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
    nerd-fonts.victor-mono
    nerd-fonts.zed-mono
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
      # brave
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
      neovim
      ntfs3g
      scrot
      gnome-keyring
      acpi
      ffmpeg_6
      pamixer
      polkit
      polkit_gnome
      bluez
      glxinfo
      virtualglLib
      clinfo
      nvd
      nix-output-monitor
      mpv
      lxqt.lxqt-openssh-askpass
      vulkan-tools
      alsa-utils
      # alsa-lib
      # xz
      # libGLU
      # clang
      # cmake
      # ninja
      # pkg-config
      # gtk3
      # lzlib
      # libgcc
      # ocamlPackages.alsa
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
    package = pkgs.nixVersions.latest;
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
    stateVersion = "24.11";
  };

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

}
