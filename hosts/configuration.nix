# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, user, location, ... }:
{
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

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

  # Enable sound.
  sound.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      driSupport = true;
    };
    pulseaudio.enable = false;
  };

  programs = {
    adb.enable = true;
    nm-applet.enable = true;
    gnupg.agent = {
        enable = true;
        enableSSHSupport =true;
    };
  };

  security.rtkit.enable = true;
  services = {
    udev.packages = [
     pkgs.android-udev-rules
    ];
    gnome.gnome-keyring.enable = true;
    pcscd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" ];
    initialPassword = "123456";
  };

  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ]; 

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      brave
      fish
      alacritty
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
      exa
      stow
      starship
      picom
      rofi
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
      scrot
      gnome.gnome-keyring
    ];
  };

  nix = {
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;
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
    stateVersion = "23.05";
  };

}
