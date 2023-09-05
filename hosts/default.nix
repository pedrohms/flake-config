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

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vm
    ];
  };

  vmdesktop = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs myFlakeVersion; };
    modules = [
      ./vmdesktop
    ];
  };
}
