{ lib, inputs, nixpkgs, home-manager, user, location, my-overlays, ... }:

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
    specialArgs = { inherit inputs user location pkgs; }; # Pass flake variable
    modules = [                                             # Modules that are used.
      ./notepedro
      ./configuration.nix
    ];
  };

  desenv07 = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs ; };
    modules = [
      ./desenv07
      ./configuration.nix
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = { inherit inputs user location pkgs; };
    modules = [
      ./vm
      ./configuration.nix
    ];
  };
}
