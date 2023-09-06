#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./virtualisation
#               └─ default.nix *
#

[
  ./docker.nix
  ./qemu.nix
  ./vbox.nix
  ./podman.nix
]
