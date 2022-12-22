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

{ config, pkgs, ... }:

{
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    ../../modules/virtualization/podman.nix
  ] ;

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {                                  # For legacy boot:
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";                    # Name of harddrive (can also be vda)
      };
      timeout = 1;                              # Grub auto select time
    };
  };

  services = {
  };
}
