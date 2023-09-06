
#  Awesome configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./awesome
#               └─ default.nix *
#

{ inputs, config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git;
      };
    };
  };
}
