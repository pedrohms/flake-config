#
#  Dwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./dwm
#               └─ default.nix *
#

{ config, lib, pkgs, ... }:
let
  dwm = pkgs.dwm.overrideAttrs (oldAttrs: rec {
    patches = [
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
        sha256 = "1gksmq7ad3fs25afgj8irbwcidhyzh0cmba7vkjlsmbdgrc131yp";
      })
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
        sha256 = "1lbzjr972s42x8b9j6jx82953jxjjd8qna66x5vywaibglw4pkq1";
      })
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/fancybar/dwm-fancybar-20220527-d3f93c7.diff";
        sha256 = "1q4318676aavvx7kiwqab4wzaq5y7b1n90cskpdgx1v3nvkq4s4x";
      })
      (pkgs.fetchpatch {
        url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff";
        sha256 = "0qymdjh7b2smbv37nrh0ifk7snm07y4hhw7yiizh6kp2kik46392";
      })
    ];
    configFile = pkgs.writeText "config.h" (builtins.readFile ./dwm-config.h);
    postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
  });
in 
{
  services = {
    xserver = {
      windowManager= {
        dwm = {                                 # Window Manager
          enable = true;
        };
      };
    };
  };
}
