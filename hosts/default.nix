{ lib, inputs, nixpkgs, home-manager, user, location, my-overlays, myFlakeVersion, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system ;
    config.allowUnfree = true;                              # Allow proprietary software
    overlays = my-overlays;
  };

  lib = nixpkgs.lib;
in
{
  notepedro = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; }; # Pass flake variable
    modules = [                                             # Modules that are used.
      ./notepedro
      ./configuration.nix
    ];
  };

  desenv07 = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./desenv07
      ./configuration.nix
    ];
  };

  g15 = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; }; # Pass flake variable
    modules = [                                             # Modules that are used.
      ./g15
      ./configuration.nix
    ];
  };

  vmware = lib.nixosSystem {                                    # VM profile - VMware
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vm
      ../modules/virtualisation/guest/vmware.nix
    ];
  };

  virtualbox = lib.nixosSystem {                                    # VM profile - VirtualBox
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vm
      ../modules/virtualisation/guest/virtualbox.nix
    ];
  };

  vmware-desktop = lib.nixosSystem {                                    # VM profile - VMware
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vmdesktop
      ../modules/virtualisation/guest/vmware.nix
    ];
  };

  virtualbox-desktop = lib.nixosSystem {                                    # VM profile - VirtualBox
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vmdesktop
      ../modules/virtualisation/guest/virtualbox.nix
    ];
  };
}
