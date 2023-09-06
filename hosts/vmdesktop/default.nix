#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, lib, pkgs, inputs, user, location , myFlakeVersion, ... }:

{
  imports =                                   # For now, if applying to other system, swap files
    [(./hardware-configuration.nix) ] ++               # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    ( import ./desktop.nix) ++
    ( import ./virtualisation.nix);

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot:
      grub = {
        enable = true;
        device = "/dev/sda";                    # Name of harddrive (can also be vda)
      };
      timeout = 1;                              # Grub auto select time
    };
  };

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

  programs = {
    fish.enable = true;
    gnupg.agent = {
        enable = true;
        enableSSHSupport =true;
    };
    direnv = {
      enable = true;
      package = pkgs.direnv;
      silent = true;
      persistDerivations = true;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };
  };

  security.rtkit.enable = true;
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
    };
    xserver = {
      layout = "us";
      xkbVariant = "intl";
      displayManager.sessionCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual-1 --mode 1920x1080
      '';
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
  };

  users.users.vmuser = {
    uid = 1001;
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp" "scanner" "plugdev" "sambashare" "kvm" "libvirtd" "camera" "adbusers" "plugdev" "users" ];
    initialPassword = "123456";
  };
  users.groups.vmuser = {
    gid = 1001;
    members = [ "vmuser" ];
  };

  fonts.packages = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    nerdfonts
#   (nerdfonts.override {                   # Nerdfont Icons override
#     fonts = [
#       "FiraCode"
#     ];
#   })
  ]; 

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      alsa-utils
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      fish
      lshw
      networkmanagerapplet
      killall
      unzip
      zip
      pciutils
      usbutils
      exa
      stow
      starship
      tmux
      lazygit
      fzf
      feh
      bat
      ripgrep
      neovim-nightly
      alacritty
      tmux
      dmenu
      home-manager
      picom
      wireplumber
      conky
      lxde.lxsession
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
    stateVersion = "23.11";
  };

}
