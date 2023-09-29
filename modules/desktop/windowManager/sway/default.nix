#  Sway configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./sway
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  programs = {
    sway = {
      enable = true;
    };
  };
}
